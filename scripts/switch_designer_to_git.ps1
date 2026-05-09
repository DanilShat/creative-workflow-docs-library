param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl,
    [string]$AppRoot = "C:\creative-workflow-worker\app",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or is not on PATH."
}

$workerRoot = Split-Path $AppRoot -Parent
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $workerRoot "app_zip_backup_$timestamp"

if (Test-Path (Join-Path $AppRoot ".git")) {
    Write-Host "Git checkout already exists at $AppRoot. Running update instead." -ForegroundColor Cyan
    powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $AppRoot "scripts\update_designer_from_git.ps1") -AppRoot $AppRoot -Branch $Branch
    exit 0
}

$envBackup = $null
if (Test-Path (Join-Path $AppRoot ".env.worker")) {
    $envBackup = Join-Path $env:TEMP "creative_workflow_env_worker_$timestamp"
    Copy-Item (Join-Path $AppRoot ".env.worker") $envBackup -Force
}

if (Test-Path $AppRoot) {
    Write-Host "Moving current zip-based app to $backupRoot" -ForegroundColor Yellow
    Move-Item -LiteralPath $AppRoot -Destination $backupRoot
}

New-Item -ItemType Directory -Force -Path $workerRoot | Out-Null
git clone --branch $Branch $RepoUrl $AppRoot
Set-Location $AppRoot

if ($envBackup -and (Test-Path $envBackup)) {
    Copy-Item $envBackup ".env.worker" -Force
    Remove-Item $envBackup -Force
    Write-Host "Preserved existing .env.worker from the zip-based install." -ForegroundColor Green
} else {
    Copy-Item ".env.worker.example" ".env.worker"
    Write-Host "Created .env.worker from example. Edit SERVER_BASE_URL and WORKER_TOKEN before running worker." -ForegroundColor Yellow
}

powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\update_designer_from_git.ps1" -AppRoot $AppRoot -Branch $Branch

Write-Host ""
Write-Host "Designer laptop now uses git updates from $RepoUrl" -ForegroundColor Green
Write-Host "Old zip app backup: $backupRoot"
