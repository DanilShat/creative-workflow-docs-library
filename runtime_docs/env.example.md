# Environment examples

## Server `.env`
```env
DATABASE_URL=postgresql+psycopg://creative:creative@localhost:5432/creative_workflow
SERVER_PUBLIC_BASE_URL=http://192.168.1.10:8000
ARTIFACT_ROOT=D:/creative-workflow/artifacts
SERVER_SECRET=change-me-long-random-secret
ALLOW_WORKER_REGISTRATION=false
TRUSTED_WORKER_IDS=designer-laptop-01
OLLAMA_BASE_URL=http://127.0.0.1:11434
OLLAMA_MODEL=gemma3n:e2b
```

## Worker `.env`
```env
SERVER_BASE_URL=http://192.168.1.10:8000
WORKER_ID=designer-laptop-01
WORKER_TOKEN=paste-generated-token-here
WORKER_TEMP_ROOT=C:/creative-workflow-worker/temp
PLAYWRIGHT_PROFILE_ROOT=C:/creative-workflow-worker/profiles
WORKER_CAPABILITIES=browser.playwright,browser.gemini,browser.freepik,agent.chat

# Local agent routing. These use subscription CLI logins on this laptop, not API keys.
# Ollama runs on the operator laptop, not on designer workers.
CLAUDE_CLI_EXECUTABLE=claude
CODEX_CLI_EXECUTABLE=codex
CLAUDE_CLI_STATUS_ARGS=auth status
CODEX_CLI_STATUS_ARGS=login status
CLAUDE_CLI_CHAT_ARGS=--print --permission-mode dontAsk
CODEX_CLI_CHAT_ARGS=exec --ask-for-approval never --sandbox read-only -
```

## Optional Claude MCP `.env`
```env
CLAUDE_MCP_SERVER_NAME=creative-workflow-tools
SERVER_BASE_URL=http://192.168.1.10:8000
WORKER_ID=designer-laptop-01
WORKER_TOKEN=paste-generated-token-here
MCP_ALLOWED_ACTIONS=get_current_task_context,list_available_actions,submit_review_note,request_photoshop_action_job,request_aftereffects_action_job
```
