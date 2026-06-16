import os
import yaml
from typing import Dict, Any
from .model_trainer import ModelTrainer
from .model_versioner import ModelVersioner
from .performance_monitor import PerformanceMonitor
from .anomaly_detector import AnomalyDetector
from .scheduler import LearnerScheduler

class ContinuousLearner:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/learning.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        self.trainer = ModelTrainer(self.config)
        self.versioner = ModelVersioner(self.config)
        self.monitor = PerformanceMonitor(self.config)
        self.anomaly_detector = AnomalyDetector(self.config)
        self.scheduler = LearnerScheduler(self.config)

    async def start(self):
        """Starts background learning processes."""
        await self.scheduler.start()

__all__ = ["ContinuousLearner", "ModelTrainer", "ModelVersioner", "PerformanceMonitor", "AnomalyDetector"]
