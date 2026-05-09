# GitHub Update Workflow

Public repository:

```text
https://github.com/DanilShat/creative-workflow-gate-a
```

## What Git Tracks

The repository tracks source code, specs, docs, migrations, scripts, and tests.
It intentionally does not track:

- `.env.server`
- `.env.worker`
- `dist/`
- `runtime_logs/`
- Python caches and package build metadata

Those ignored files can contain local secrets, worker tokens, machine paths, or
runtime output.

## Operator Laptop: Publish

Install GitHub CLI if it is missing:

```powershell
winget install -e --id GitHub.cli --accept-source-agreements --accept-package-agreements
```

Authenticate:

```powershell
gh auth login
```

Create a public GitHub repository from this local checkout:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
gh repo create creative-workflow-gate-a --public --source . --remote origin --push
```

If the repo already exists on GitHub:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
git remote add origin https://github.com/<owner>/creative-workflow-gate-a.git
git push -u origin main
```

For this project the remote is:

```powershell
git remote add origin https://github.com/DanilShat/creative-workflow-gate-a.git
```

## Operator Laptop: Normal Updates

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
git status
git add .
git commit -m "Describe the change"
git push
```

Run tests before pushing code changes:

```powershell
python -m pytest tests -q
```

## Designer Laptop: One-Time Switch From Zip To Git

Stop the worker first. Then run:

```powershell
cd C:\creative-workflow-worker\app
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\switch_designer_to_git.ps1 `
  -RepoUrl https://github.com/DanilShat/creative-workflow-gate-a.git
```

The script moves the old zip-based app to a timestamped backup folder,
clones the GitHub repo into `C:\creative-workflow-worker\app`, preserves the
existing `.env.worker`, reinstalls the Python package, and recreates shortcuts.

## Designer Laptop: Pull Updates

After the one-time switch:

```powershell
cd C:\creative-workflow-worker\app
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\update_designer_from_git.ps1
```

Then start the worker:

```powershell
python -m creative_workflow.worker.cli run
```

## History Note

This repo was initialized after the first MVP implementation already existed.
The exact pre-git edit history cannot be reconstructed from the filesystem.
The first commit is a current-state import; future changes should be committed
as small, descriptive commits.
