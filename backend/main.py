import uvicorn
from fastapi import FastAPI

# Import modules (stubs)
# from api import router
# from modules.ingestion import IngestionService
# from modules.decision import DecisionEngine

app = FastAPI(title="ForexAI Backend")

@app.get("/")
async def root():
    return {"message": "ForexAI Backend is running"}

def start_background_services():
    """
    Start all background services like data ingestion,
    continuous learning, and risk monitoring.
    """
    print("Starting background services...")
    # Example:
    # ingestion_service = IngestionService()
    # ingestion_service.start()
    pass

if __name__ == "__main__":
    start_background_services()
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
