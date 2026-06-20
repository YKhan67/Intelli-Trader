import asyncio
import os
import sys
import logging
from datetime import datetime

# Path resolution
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.modules.learner.continuous_learner import ContinuousLearner

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("AuditorSection")

async def run_auditor():
    print("\n" + "="*60)
    print("SECTION 3: THE AUDITOR (Monitoring & Self-Correction)")
    print("="*60)
    
    # Initialize the Auditor
    # It reads config from backend/config/learning.yaml
    auditor = ContinuousLearner()
    
    logger.info("Auditor Section launching background monitoring...")
    
    try:
        # This will run the audit loop every 15 minutes
        await auditor.start()
    except asyncio.CancelledError:
        logger.info("Auditor received shutdown signal.")
    except Exception as e:
        logger.error(f"Auditor failed: {e}")
    finally:
        auditor.stop()
        logger.info("Auditor Section stopped.")

if __name__ == "__main__":
    try:
        asyncio.run(run_auditor())
    except KeyboardInterrupt:
        pass
