param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$desktop = [Environment]::GetFolderPath("Desktop")

function Write-CmdShortcut {
    param([string]$Name, [string]$Command)
    $path = Join-Path $desktop $Name
    Set-Content -Path $path -Value @"
@echo off
cd /d "$RepoRoot"
$Command
pause
"@ -Encoding ASCII
    Write-Host "Created $path"
}

Write-CmdShortcut "Creative Workflow Local Sandbox Start.cmd" "powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\start_local_sandbox.ps1"
Write-CmdShortcut "Creative Workflow Local Sandbox Stop.cmd" "powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\stop_local_sandbox.ps1"
Set-Content -Path (Join-Path $desktop "Creative Workflow Local UI.url") -Value @(
    "[InternetShortcut]",
    "URL=http://127.0.0.1:8501"
) -Encoding ASCII

Write-Host "Created Creative Workflow Local UI.url"
