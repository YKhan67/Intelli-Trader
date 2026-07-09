import asyncio
import logging
import multiprocessing
import os
import signal
from typing import List, Dict, Any
from concurrent.futures import ProcessPoolExecutor
from backend.modules.indicators import IndicatorCalculator
from backend.modules.smc import SMCManager
from .model_trainer import ModelTrainer

logger = logging.getLogger("LearningEngine")

def _worker_process_task(pair: str, timeframes: List[str]):
    """
    Isolated worker process task.
    Handles all timeframes for a single pair to minimize DB context switching.
    """
    # Ignore SIGINT in workers so the parent can handle the graceful shutdown
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    
    # 1. New Event Loop for this process
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    
    # 2. Local process logging
    logging.basicConfig(level=logging.INFO)
    p_logger = logging.getLogger(f"Worker-{pair}")

    # 3. Inside the process, we must re-initialize the DB engine via lazy import
    from backend.modules.indicators import IndicatorCalculator
    from backend.modules.smc import SMCManager
    
    indicators = IndicatorCalculator()
    smc = SMCManager()
    
    async def run():
        p_logger.info(f">>> PID {os.getpid()} starting decade processing for {pair}")
        for tf in timeframes:
            try:
                # 1. High Speed Vectorized Indicators
                await indicators.calculate_bulk(pair, tf)
                # 2. Pattern-matching SMC Zones (Looking back 10 years)
                await smc.update_zones(pair, tf, lookback_bars=100000) 
            except Exception as e:
                p_logger.error(f"Error in {pair} {tf}: {e}")
        p_logger.info(f"<<< PID {os.getpid()} finished {pair}")

    try:
        loop.run_until_complete(run())
    finally:
        loop.close()

class LearningEngine:
    def __init__(self):
        self.indicators = IndicatorCalculator()
        self.smc = SMCManager()
        self.trainer = ModelTrainer({}) 
        self._executor = None

    async def run_historical_processing(self, pairs: List[str], timeframes: List[str]):
        """
        Orchestrates massive parallel historical processing.
        Utilizes 56 cores by distributing pairs across physical CPU resources.
        Includes safety handlers for Ctrl-C.
        """
        logger.info(f"=== 56-CORE INSTITUTIONAL PROCESSING STARTING ===")
        num_workers = len(pairs)
        
        loop = asyncio.get_running_loop()
        self._executor = ProcessPoolExecutor(max_workers=num_workers)
        
        try:
            tasks = [
                loop.run_in_executor(self._executor, _worker_process_task, pair, timeframes)
                for pair in pairs
            ]
            await asyncio.gather(*tasks)
            logger.info("=== 56-CORE HISTORICAL PROCESSING COMPLETE ===")
                
        except asyncio.CancelledError:
            logger.warning("!!! Interruption Detected: Shutting down 56-core grid safely...")
            if self._executor:
                self._executor.shutdown(wait=False, cancel_futures=True)
            raise
        except Exception as e:
            logger.error(f"Processing grid error: {e}")
            if self._executor:
                self._executor.shutdown(wait=False)
            raise
        finally:
            if self._executor:
                self._executor.shutdown(wait=True)
                self._executor = None

    async def train_models(self, pairs: List[str]):
        """
        Triggers high-performance model training using all 56 cores (n_jobs=-1).
        """
        logger.info("=== STARTING 56-CORE MACHINE LEARNING PHASE ===")
        try:
            results = await self.trainer.retrain_all(pairs)
            logger.info(f"Training Results: {results}")
            logger.info("=== ML TRAINING COMPLETE ===")
        except KeyboardInterrupt:
            logger.warning("ML Training interrupted by user. Cleaning up...")
            raise
