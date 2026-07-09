import uvicorn
import os
import sys
import logging

# Path normalization for institutional imports
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

# Global logging configuration
log_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "logs")
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(log_dir, "backend.log")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler(log_file, encoding="utf-8")
    ]
)
logger = logging.getLogger("Launcher")

if __name__ == "__main__":
    logger.info(">>> BOOTING INSTITUTIONAL AI CLUSTER ON PORT 8081 <<<")
    
    # LOGICAL FIX: Relaxing WebSocket timeouts for high-load 56-core environment.
    # Aggressive 10s timeouts cause flickering on Windows when CPU is peaked.
    uvicorn.run(
        "backend.api.main:app", 
        host="0.0.0.0", 
        port=8081, 
        log_level="info",
        ws_ping_interval=60, # Increased to 60s
        ws_ping_timeout=30   # Increased to 30s
    )
