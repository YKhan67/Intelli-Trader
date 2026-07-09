import asyncio
import json
import sys
import MetaTrader5 as mt5
import websockets
import logging
from datetime import datetime, timezone, timedelta
from sqlalchemy import select, update, text
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB
from backend.database.redis_client import get_redis_client

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("MT5Bridge")

class MT5Bridge:
    def __init__(self):
        self.magic_number = 123456
        self.redis = get_redis_client()

    async def handle_client(self, websocket):
        addr = "unknown"
        try:
            addr = websocket.remote_address
        except: pass
        
        logger.info(f"Client {addr} connected.")
        
        try:
            async for message in websocket:
                request_id = "0"
                try:
                    data = json.loads(message)
                    action = data.get("action")
                    params = data.get("params", {})
                    request_id = str(data.get("id", "0"))
                    
                    res_data = None
                    status = "success"
                    error_msg = None

                    if action == "PING":
                        pass
                    
                    elif action == "GET_ACCOUNT":
                        res_data = await self._get_account_info_internal()
                        if not res_data:
                            status = "error"
                            error_msg = "Could not fetch account info"

                    elif action == "GET_POSITIONS":
                        res_data = await self._get_positions_internal()

                    elif action == "PLACE_ORDER":
                        symbol = params.get("symbol")
                        order_type = params.get("type")
                        volume = float(params.get("volume", 0.01))
                        sl = float(params.get("sl", 0))
                        tp = float(params.get("tp", 0))

                        mt5_type = mt5.ORDER_TYPE_BUY if order_type == "BUY" else mt5.ORDER_TYPE_SELL
                        tick = mt5.symbol_info_tick(symbol)
                        if not tick:
                             status = "error"
                             error_msg = f"Symbol {symbol} not found"
                        else:
                            price = tick.ask if order_type == "BUY" else tick.bid
                            request = {
                                "action": mt5.TRADE_ACTION_DEAL,
                                "symbol": symbol,
                                "volume": volume,
                                "type": mt5_type,
                                "price": price,
                                "sl": sl,
                                "tp": tp,
                                "magic": self.magic_number,
                                "comment": "Intelli-Trader AI",
                                "type_time": mt5.ORDER_TIME_GTC,
                                "type_filling": mt5.ORDER_FILLING_IOC,
                            }
                            result = mt5.order_send(request)
                            if result.retcode != mt5.TRADE_RETCODE_DONE:
                                status = "error"
                                error_msg = f"Order failed: {result.comment} ({result.retcode})"
                            else:
                                res_data = {"ticket": result.order}
                                logger.info(f"Order Success: {result.order}")

                    elif action == "CLOSE_ORDER":
                        ticket = int(params.get("ticket"))
                        pos = mt5.positions_get(ticket=ticket)
                        if not pos:
                            status = "error"
                            error_msg = "Position not found"
                        else:
                            p = pos[0]
                            type = mt5.ORDER_TYPE_SELL if p.type == 0 else mt5.ORDER_TYPE_BUY
                            tick = mt5.symbol_info_tick(p.symbol)
                            price = tick.bid if p.type == 0 else tick.ask
                            request = {
                                "action": mt5.TRADE_ACTION_DEAL,
                                "symbol": p.symbol,
                                "volume": p.volume,
                                "type": type,
                                "position": p.ticket,
                                "price": price,
                                "magic": self.magic_number,
                                "comment": "Close order",
                                "type_time": mt5.ORDER_TIME_GTC,
                                "type_filling": mt5.ORDER_FILLING_IOC,
                            }
                            result = mt5.order_send(request)
                            if result.retcode != mt5.TRADE_RETCODE_DONE:
                                status = "error"
                                error_msg = f"Close failed: {result.comment}"
                            else:
                                status = "success"

                    await self._sync_closed_trades()
                    await self._broadcast_state_to_redis()

                    response = {"id": request_id, "status": status}
                    if res_data is not None: response["data"] = res_data
                    if error_msg: response["error"] = error_msg
                    await websocket.send(json.dumps(response))

                except Exception as e:
                    logger.error(f"Processing Error: {e}")
                    try:
                        await websocket.send(json.dumps({"id": request_id, "status": "error", "error": str(e)}))
                    except: pass
                    
        except Exception as e:
            logger.warning(f"Connection error: {e}")
        finally:
            logger.info(f"Client {addr} disconnected.")

    async def _get_account_info_internal(self):
        acc = mt5.account_info()
        if acc:
            return {
                "balance": float(acc.balance), "equity": float(acc.equity),
                "margin": float(acc.margin), "free_margin": float(acc.margin_free),
                "margin_level": float(acc.margin_level), "currency": str(acc.currency),
                "leverage": float(acc.leverage), "account_number": str(acc.login),
                "broker_name": "MetaTrader 5"
            }
        return None

    async def _get_positions_internal(self):
        p = mt5.positions_get()
        return [{
            "broker_ticket_id": str(x.ticket), "pair": str(x.symbol),
            "direction": "LONG" if x.type == 0 else "SHORT",
            "lot_size": float(x.volume), "entry_price": float(x.price_open),
            "current_price": float(x.price_current), "stop_loss": float(x.sl),
            "take_profit": float(x.tp),
            "open_time": datetime.fromtimestamp(x.time, tz=timezone.utc).isoformat()
        } for x in p] if p else []

    async def _broadcast_state_to_redis(self):
        try:
            acc = await self._get_account_info_internal()
            if acc:
                await self.redis.set("state:account", json.dumps(acc), ex=60)
                date_str = datetime.now(timezone.utc).strftime('%Y-%m-%d')
                initial_key = f"pnl:initial_balance:{date_str}"
                initial_bal = await self.redis.get(initial_key)
                
                if not initial_bal:
                    await self.redis.set(initial_key, acc['balance'], ex=90000)
                    daily_pnl = 0.0
                else:
                    daily_pnl = acc['balance'] - float(initial_bal)
                
                await self.redis.set(f"pnl:daily:{date_str}", daily_pnl, ex=86400)

            positions = await self._get_positions_internal()
            await self.redis.set("state:positions", json.dumps(positions), ex=60)
        except Exception as e:
            logger.error(f"Redis Broadcast Error: {e}")

    async def run_periodic_sync(self):
        while True:
            try:
                await self._sync_closed_trades()
                await self._broadcast_state_to_redis()
            except Exception as e:
                logger.error(f"Periodic Sync Error: {e}")
            await asyncio.sleep(5)

    async def _sync_closed_trades(self):
        try:
            from_date = datetime.now() - timedelta(hours=24)
            history = mt5.history_deals_get(from_date, datetime.now())
            if not history: return

            async with AsyncSessionLocal() as session:
                for deal in history:
                    if deal.magic == self.magic_number and deal.entry == mt5.DEAL_ENTRY_OUT:
                        stmt = select(TradeDB).where(TradeDB.broker_order_id == str(deal.position_id))
                        trade = (await session.execute(stmt)).scalar_one_or_none()
                        
                        if trade and trade.status != 'CLOSED':
                            trade.exit_price = float(deal.price)
                            trade.exit_time = datetime.fromtimestamp(deal.time, tz=timezone.utc)
                            trade.profit_loss = float(deal.profit)
                            trade.net_profit_loss = float(deal.profit + deal.commission + deal.swap)
                            trade.status = 'CLOSED'
                            trade.exit_reason = "BROKER_EXIT"
                            logger.info(f"DB SYNC: Trade {trade.trade_uuid} closed via MT5. PnL: {trade.net_profit_loss}")
                await session.commit()
        except Exception as e:
            logger.error(f"Failed to sync closed trades: {e}")

async def main():
    if not mt5.initialize():
        print("CRITICAL: MetaTrader 5 Terminal NOT FOUND. Ensure MT5 is open.")
        return
    bridge = MT5Bridge()
    print(f"SUCCESS: MT5 Link Active (Terminal Build {mt5.version()[1]})")
    asyncio.create_task(bridge.run_periodic_sync())
    async with websockets.serve(bridge.handle_client, "0.0.0.0", 8765):
        print("WebSocket Bridge running on ws://127.0.0.1:8765")
        try:
            await asyncio.Future()
        except asyncio.CancelledError:
            pass

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nShutdown signal received. Closing MT5...")
        mt5.shutdown()
