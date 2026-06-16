import uvicorn
import os
import sys
import logging

# Add project root to sys.path to resolve 'backend' imports
# This script is in [Root]/backend/main.py, so we need [Root]
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
logger = logging.getLogger("ForexAI")

if __name__ == "__main__":
    logger.info("Main: Starting server on 0.0.0.0:8000...")
    
    # Launch uvicorn pointing to the full module path
    uvicorn.run("backend.api.main:app", host="0.0.0.0", port=8000, log_level="info")
