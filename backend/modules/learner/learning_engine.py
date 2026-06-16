import asyncio
import logging
from typing import List, Dict, Any
from backend.modules.indicators import IndicatorCalculator
from backend.modules.smc import SMCManager
from .model_trainer import ModelTrainer

logger = logging.getLogger("LearningEngine")

class LearningEngine:
    def __init__(self):
        self.indicators = IndicatorCalculator()
        self.smc = SMCManager()
        self.trainer = ModelTrainer({}) 

    async def run_historical_processing(self, pairs: List[str], timeframes: List[str]):
        """
        Orchestrates historical indicator calculation and SMC zone mapping.
        """
        logger.info("=== Starting Historical Data Processing ===")
        
        for pair in pairs:
            for tf in timeframes:
                logger.info(f"Processing {pair} {tf}...")
                await self.indicators.calculate_bulk(pair, tf)
                # Map SMC zones for the whole history
                await self.smc.update_zones(pair, tf, lookback_bars=50000) 
                
        logger.info("=== Historical Data Processing Complete ===")

    async def train_models(self, pairs: List[str]):
        """
        Triggers the training of ML models based on the processed historical data.
        """
        logger.info("=== Starting Model Training Phase ===")
        results = await self.trainer.retrain_all(pairs)
        logger.info(f"Training Results: {results}")
        logger.info("=== Model Training Complete ===")
