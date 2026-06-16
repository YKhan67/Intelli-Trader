import asyncio
import os
import sys
import logging

# Path resolution: Find project root (one level above this script)
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.modules.learner import ContinuousLearner

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("AuditorSection")

async def run_auditor():
    print("\n" + "="*60)
    print("SECTION 3: THE AUDITOR (Continuous Monitoring & Correction)")
    print("="*60)
    
    learner = ContinuousLearner()
    logger.info("Auditor active. Monitoring for regime shifts and performance anomalies...")
    await learner.start()

if __name__ == "__main__":
    try:
        asyncio.run(run_auditor())
    except KeyboardInterrupt:
        logger.info("Auditor stopped by user.")
