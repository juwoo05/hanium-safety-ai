def extract_converse_text(response: dict) -> str:
    content = response.get("output", {}).get("message", {}).get("content", [])
    for block in content:
        text = block.get("text")
        if text:
            return text
    stop_reason = response.get("stopReason", "unknown")
    raise ValueError(f"Bedrock 응답에 텍스트 콘텐츠가 없습니다 (stopReason={stop_reason})")
