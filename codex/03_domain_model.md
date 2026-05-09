# Domain Model

## Primary entities
- Task
- Scene
- Asset
- Prompt
- Run
- Review
- RoutingEvent

## Workflow state shape

```python
from typing import Literal, TypedDict

class WorkflowState(TypedDict, total=False):
    task_id: str
    job_type: Literal["static", "video"]
    status: str
    brief_raw: str
    brief_structured: dict
    references: list[dict]
    routing: dict
    prompt_state: dict
    attempts: list[dict]
    review: dict
    video: dict
    ops: dict
```
