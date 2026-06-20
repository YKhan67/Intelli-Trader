from pydantic import BaseModel, Field
from typing import Optional, Any, List, Dict
from datetime import datetime
import uuid

class APIResponse(BaseModel):
    status: str = Field(default="success", description="success or error")
    message: str = Field(default="OK", description="Human-readable message")
    timestamp: datetime = Field(default_factory=lambda: datetime.now())
    request_id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    data: Optional[Any] = None

class PaginatedResponse(APIResponse):
    total: int = 0
    page: int = 1
    size: int = 50
