param(
    [int]$ApiPort = 8000,
    [int]$UiPort = 8501,
    [switch]$NoWorker
)

$ErrorActionPreference = "Stop"

function Start-ManagedProcess {
    param(
        [string]$Name,
        [string[]]$Arguments,
        [string]$StdOut,
        [string]$StdErr
    )
    $process = Start-Process -FilePath python -ArgumentList $Arguments -WorkingDirectory (Get-Location) -RedirectStandardOutput $StdOut -RedirectStandardError $StdErr -WindowStyle Hidden -PassThru
    Write-Host "$Name PID: $($process.Id)"
}

function Test-PortFree {
    param([int]$Port)
    $listener = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Where-Object { $_.State -eq "Listen" }
    if ($listener) {
        throw "Port $Port is already in use by process $($listener[0].OwningProcess). Stop it first or choose another port."
    }
}

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

if (-not (Test-Path ".env.server.local") -or -not (Test-Path ".env.worker.local")) {
    throw "Missing .env.server.local or .env.worker.local. Run scripts\setup_local_sandbox.ps1 first."
}

New-Item -ItemType Directory -Force "runtime_logs\local_sandbox" | Out-Null
Test-PortFree $ApiPort
Test-PortFree $UiPort

$serverEnv = (Resolve-Path ".env.server.local").Path
$workerEnv = (Resolve-Path ".env.worker.local").Path

$env:CREATIVE_WORKFLOW_ENV_FILE = $serverEnv
Start-ManagedProcess "Local API" @("-m", "creative_workflow.server.cli", "dev", "--host", "127.0.0.1", "--port", "$ApiPort") "runtime_logs\local_sandbox\api.out.log" "runtime_logs\local_sandbox\api.err.log"
Start-Sleep -Seconds 4

$env:CREATIVE_WORKFLOW_ENV_FILE = $serverEnv
Start-ManagedProcess "Local UI" @("-m", "creative_workflow.server.cli", "ui", "--port", "$UiPort") "runtime_logs\local_sandbox\ui.out.log" "runtime_logs\local_sandbox\ui.err.log"

if (-not $NoWorker) {
    $env:CREATIVE_WORKFLOW_ENV_FILE = $workerEnv
    Start-ManagedProcess "Local simulated worker" @("-m", "creative_workflow.worker.cli", "run") "runtime_logs\local_sandbox\worker.out.log" "runtime_logs\local_sandbox\worker.err.log"
}

Start-Sleep -Seconds 5
Write-Host ""
Write-Host "Local sandbox is starting." -ForegroundColor Green
Write-Host "UI:  http://127.0.0.1:$UiPort"
Write-Host "API: http://127.0.0.1:$ApiPort/api/v1/health"
Write-Host ""
Write-Host "Check status:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\status_local_sandbox.ps1"
Write-Host "Stop:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\stop_local_sandbox.ps1"
