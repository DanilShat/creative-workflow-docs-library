# LangGraph Workflow Specification

## Main graph

```text
START
 -> intake_task
 -> normalize_brief
 -> classify_job_type
 -> select_route
 -> route_branch

if static:
 -> static_subgraph
 -> final_review
 -> export_package
 -> END

if video:
 -> split_scenario
 -> video_scene_subgraph
 -> continuity_review
 -> export_video_package
 -> END
```

## Human interrupt points
- ambiguous brief
- repeated failed attempts
- manual prompt edit request
- scene approval
- final export confirmation
