# Provider Adapter Contracts

## Goal
Workflow nodes must not know whether a provider is browser-driven or API-driven.

## Interfaces

```python
from dataclasses import dataclass
from typing import Any

@dataclass
class GenerationRequest:
    prompt: str
    refs: list[str]
    settings: dict[str, Any]
    task_id: str
    scene_id: str | None = None

@dataclass
class GenerationResult:
    success: bool
    output_paths: list[str]
    provider: str
    mode: str
    metadata: dict[str, Any]
    raw_response: dict[str, Any] | None = None
    debug_artifacts: dict[str, str] | None = None
```
