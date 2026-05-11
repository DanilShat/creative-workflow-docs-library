# Designer Laptop SSH Handoff for Claude/Codex

## Purpose

This note explains how Codex/Claude can manage the designer laptop from the
operator laptop for faster updates, diagnostics, and smoke tests.

The connection is for command-line maintenance only. It does not provide a
shared GUI view of Chrome, Photoshop, After Effects, or Claude Desktop. GUI
validation still needs the designer or operator to watch the screen.

## Current Connection Status

SSH access from the operator laptop to the designer laptop is working.

Known values from the last successful check:

```text
Operator laptop IPv4: 192.168.1.124
Designer laptop IPv4: 192.168.1.61
Designer computer: DESKTOP-Q954L8B
Designer Windows user: User
Designer worker repo path: C:\creative-workflow-worker\app
Worker id: designer-laptop-01
Worker server URL: http://192.168.1.124:8000
```

The designer laptop may receive a different LAN IP after reboot or network
change. Re-check with:

```powershell
ipconfig | findstr IPv4
```

## SSH Key Material

The operator laptop has a dedicated SSH private key for this connection:

```text
D:\design_agent_pet_project\.ssh\creative_workflow_designer_ed25519
```

Do not commit or paste the private key. It lives only on the operator laptop.

The matching public key was installed on the designer laptop in:

```text
C:\ProgramData\ssh\administrators_authorized_keys
```

This file is used because the `User` account is in the local Administrators
group, and Windows OpenSSH reads administrator keys from the ProgramData file
instead of the user's normal `.ssh\authorized_keys`.

## Basic SSH Command

From the operator laptop:

```powershell
ssh `
  -i D:\design_agent_pet_project\.ssh\creative_workflow_designer_ed25519 `
  User@192.168.1.61 `
  "powershell.exe -NoProfile -Command `$env:COMPUTERNAME; whoami"
```

For complex PowerShell commands, prefer `-EncodedCommand` from the operator
side. It avoids Windows quoting problems over SSH.

Example:

```powershell
$remote = @'
$ErrorActionPreference = "Stop"
Write-Host "COMPUTER=$env:COMPUTERNAME"
Write-Host "USER=$(whoami)"
Set-Location "C:\creative-workflow-worker\app"
python --version
python -m creative_workflow.worker.cli config check
'@

$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($remote))

ssh `
  -i D:\design_agent_pet_project\.ssh\creative_workflow_designer_ed25519 `
  User@192.168.1.61 `
  powershell.exe -NoProfile -EncodedCommand $encoded
```

## Verified Remote State

The last successful remote diagnostic confirmed:

- SSH login works.
- `C:\creative-workflow-worker\app` exists.
- Python is installed: `Python 3.11.9`.
- Worker config is valid.
- Worker points at the operator server: `http://192.168.1.124:8000`.
- Capabilities are `browser.playwright,browser.gemini,browser.freepik`.

The remote diagnostic also showed:

- `git` is not available in the SSH session.

Until Git is installed or added to PATH on the designer laptop, remote
`git pull` will not work. Use the local designer PowerShell for Git updates,
or install Git for Windows and make sure `git.exe` is available in the system
PATH used by SSH sessions.

## Safe Remote Commands

Use these for low-risk diagnostics:

```powershell
python --version
python -m creative_workflow.worker.cli config check
python -m creative_workflow.worker.cli healthcheck
python -m playwright --version
Test-Path "C:\creative-workflow-worker\app\.env.worker"
Get-Content "C:\creative-workflow-worker\app\.env.worker"
```

Be careful with `.env.worker`: it contains the worker token. It is acceptable
to inspect it locally for diagnostics, but do not paste the token into GitHub,
Claude chat, or documentation.

## Useful Remote Maintenance Commands

Once Git is installed on the designer laptop:

```powershell
Set-Location "C:\creative-workflow-worker\app"
git pull
python -m pip install -e ".[test]"
python -m playwright install chromium
python -m pytest tests -q
```

To run worker checks:

```powershell
Set-Location "C:\creative-workflow-worker\app"
python -m creative_workflow.worker.cli config check
python -m creative_workflow.worker.cli profile status
python -m creative_workflow.worker.cli healthcheck
```

To register Claude Desktop MCP after updates:

```powershell
Set-Location "C:\creative-workflow-worker\app"
powershell -NoProfile -ExecutionPolicy Bypass -File `
  .\scripts\register_mcp_with_claude_desktop.ps1 `
  -EnvFile "C:\creative-workflow-worker\app\.env.worker"
```

Then restart Claude Desktop manually on the designer laptop.

## What SSH Cannot Validate Alone

SSH can run commands and read logs, but it cannot prove visual/browser/DCC
success by itself.

Manual or screen-visible checks are still required for:

- Chrome/Gemini/Freepik login state.
- Claude Desktop MCP server green/running status.
- Photoshop UXP panel loading.
- Photoshop document actions.
- After Effects render behavior with a real `.aep` project.

## Troubleshooting Notes

If SSH stops working:

1. Confirm the designer IP:
   ```powershell
   ipconfig | findstr IPv4
   ```
2. Confirm the SSH service is running on the designer laptop:
   ```powershell
   Get-Service sshd
   ```
3. Confirm the admin key file still exists:
   ```powershell
   Test-Path C:\ProgramData\ssh\administrators_authorized_keys
   icacls C:\ProgramData\ssh\administrators_authorized_keys
   ```
4. Restart SSH:
   ```powershell
   Restart-Service sshd
   ```

If login fails with `Permission denied`, check that the public key in
`administrators_authorized_keys` matches the public key generated from the
operator private key:

```powershell
ssh-keygen -y -f D:\design_agent_pet_project\.ssh\creative_workflow_designer_ed25519
```

The first key attempt accidentally used a passphrase-protected private key.
That failed in non-interactive SSH because the client could not prompt for the
passphrase. The current key is intentionally unencrypted for automation, so it
must stay local and uncommitted.

## Safety Rules for Future Agents

- Never commit SSH private keys, `.env.worker`, browser profiles, cookies, or
  generated artifacts.
- Prefer read-only diagnostics before changing the designer laptop.
- Do not run destructive filesystem cleanup commands over SSH unless the exact
  path has been verified.
- Do not automate login bypasses or cookie extraction.
- Do not claim Photoshop/After Effects live success unless a real app action
  was observed or a real `aerender.exe` job produced an output file.
