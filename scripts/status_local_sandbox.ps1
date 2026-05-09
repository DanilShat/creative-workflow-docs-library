param(
    [int[]]$Ports = @(8000, 8501)
)

$ErrorActionPreference = "Stop"

Write-Host "Ports" -ForegroundColor Cyan
Get-NetTCPConnection -LocalPort $Ports -ErrorAction SilentlyContinue | Select-Object LocalAddress,LocalPort,State,OwningProcess

Write-Host ""
Write-Host "API health" -ForegroundColor Cyan
try {
    Invoke-RestMethod "http://127.0.0.1:8000/api/v1/health" -TimeoutSec 5 | ConvertTo-Json -Compress
} catch {
    Write-Host "API health failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Worker state" -ForegroundColor Cyan
$workerState = "D:\creative-workflow-local\worker-temp\worker_state.json"
if (Test-Path $workerState) {
    Get-Content $workerState
} else {
    Write-Host "No local worker_state.json found yet."
}

Write-Host ""
Write-Host "Recent logs" -ForegroundColor Cyan
foreach ($log in @(
    "runtime_logs\local_sandbox\api.err.log",
    "runtime_logs\local_sandbox\ui.err.log",
    "runtime_logs\local_sandbox\worker.err.log"
)) {
    Write-Host ""
    Write-Host $log -ForegroundColor DarkCyan
    if (Test-Path $log) {
        Get-Content $log -Tail 30
    } else {
        Write-Host "missing"
    }
}
