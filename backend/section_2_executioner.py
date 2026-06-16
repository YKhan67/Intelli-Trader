import uvicorn
import os
import sys
import logging

# Path resolution: Find project root (one level above this script)
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("ExecutionerSection")

if __name__ == "__main__":
    print("\n" + "="*60)
    print("SECTION 2: THE EXECUTIONER (Live Trading & API)")
    print("="*60)
    
    # Target path relative to project root
    app_path = "backend.api.main:app"

    logger.info("Launching Executioner on http://0.0.0.0:8000")
    uvicorn.run(app_path, host="0.0.0.0", port=8000, log_level="info")
