from fastapi import HTTPException, Security, status
from fastapi.security import APIKeyHeader

from config import INTERNAL_API_KEY

_api_key_header = APIKeyHeader(name="X-API-Key", auto_error=False)


def verify_api_key(api_key: str | None = Security(_api_key_header)) -> None:
    if not INTERNAL_API_KEY or api_key != INTERNAL_API_KEY:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or missing API key")
