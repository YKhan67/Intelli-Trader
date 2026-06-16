import sys
import os
sys.path.append(os.getcwd())
from backend.api import create_app
app = create_app()
for route in app.routes:
    if hasattr(route, "path"):
        print(f"Path: {route.path}")
