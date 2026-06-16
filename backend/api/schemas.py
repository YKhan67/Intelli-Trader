from pydantic import BaseModel, Field
from typing import Optional, Any, List, Dict
from datetime import datetime
import uuid

class APIResponse(BaseModel):
    status: str = Field(..., description="success or error")
    message: str = Field(..., description="Human-readable message")
    timestamp: datetime = Field(default_factory=lambda: datetime.now())
    request_id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    data: Optional[Any] = None

class PaginatedResponse(APIResponse):
    total: int
    page: int
    size: int

class SystemStatusResponse(BaseModel):
    health: str
    model_version: str
    uptime_seconds: float
    last_bar_processed: Optional[datetime]
    data_freshness: Dict[str, datetime]

class SettingsUpdateRequest(BaseModel):
    trading_mode: str
    active_pairs: List[str]
