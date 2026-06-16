import asyncio
import logging
import schedule
import time
from datetime import datetime, timezone
from typing import Dict, Any

from .model_trainer import ModelTrainer
from .model_versioner import ModelVersioner
from .performance_monitor import PerformanceMonitor

logger = logging.getLogger("LearnerScheduler")

class LearnerScheduler:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.trainer = ModelTrainer(config)
        self.versioner = ModelVersioner(config)
        self.monitor = PerformanceMonitor(config)
        self.is_running = False

    async def start(self):
        """Starts the background scheduling loop."""
        if self.is_running: return
        self.is_running = True
        logger.info("Continuous Learner Scheduler started.")

        # 1. Daily at 1am UTC: Retrain models
        schedule.every().day.at("01:00").do(
            lambda: asyncio.create_task(self.trainer.retrain_all(["EURUSD"]))
        )

        # 2. Daily: Check evaluation / promotion
        schedule.every().day.at("02:00").do(
            lambda: asyncio.create_task(self.versioner.promote_models())
        )

        # 3. Hourly: Performance Monitor
        schedule.every().hour.do(
            lambda: asyncio.create_task(self.monitor.daily_check())
        )

        # 4. Run the loop
        while self.is_running:
            schedule.run_pending()
            await asyncio.sleep(60)

    def stop(self):
        self.is_running = False
