import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.learner import ContinuousLearner

async def main():
    print("=== CONTINUOUS LEARNER INITIALIZATION TEST ===")
    try:
        learner = ContinuousLearner()
        print("SUCCESS: ContinuousLearner initialized correctly.")
        
        print("\nLearning Module components:")
        print(f" - Model Trainer: Ready (Window: {learner.trainer.config.get('retrain_window_days')} days)")
        print(f" - Model Versioner: Ready (Eval period: {learner.versioner.config.get('paper_eval_days')} days)")
        print(f" - Performance Monitor: Ready")
        print(f" - Anomaly Detector: Ready (StdDev Threshold: {learner.anomaly_detector.config.get('std_dev_threshold')})")
        
    except Exception as e:
        print(f"Error during learner test: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
