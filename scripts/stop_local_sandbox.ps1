param(
    [int[]]$Ports = @(8000, 8501)
)

$ErrorActionPreference = "Stop"

$listeners = foreach ($port in $Ports) {
    Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Where-Object { $_.State -eq "Listen" }
}

foreach ($listener in $listeners) {
    Write-Host "Stopping process $($listener.OwningProcess) on port $($listener.LocalPort)"
    Stop-Process -Id $listener.OwningProcess -Force -ErrorAction SilentlyContinue
}

$workerState = "D:\creative-workflow-local\worker-temp\worker_state.json"
if (Test-Path $workerState) {
    $state = Get-Content $workerState -Raw | ConvertFrom-Json
    Write-Host "Last local worker state: $($state.status), active job: $($state.active_job_id)"
}

Start-Sleep -Seconds 2
Get-NetTCPConnection -LocalPort $Ports -ErrorAction SilentlyContinue | Select-Object LocalAddress,LocalPort,State,OwningProcess
