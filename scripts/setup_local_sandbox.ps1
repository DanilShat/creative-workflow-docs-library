param(
    [string]$DatabaseUrl = "postgresql+psycopg://creative:creative@localhost:5432/creative_workflow",
    [string]$ArtifactRoot = "D:/creative-workflow-local/artifacts",
    [string]$OllamaModel = "gemma3n:e2b",
    [string]$WorkerId = "local-sim-worker-01",
    [switch]$SkipInstall,
    [switch]$SkipDbMigrate,
    [switch]$SkipLlmCheck,
    [switch]$SkipPlaywrightInstall
)

$ErrorActionPreference = "Stop"

function Set-EnvValue {
    param([string]$Path, [string]$Key, [string]$Value)
    $lines = @()
    if (Test-Path $Path) {
        $lines = Get-Content -Path $Path
    }
    $pattern = "^$([regex]::Escape($Key))="
    $updated = $false
    $newLines = foreach ($line in $lines) {
        if ($line -match $pattern) {
            $updated = $true
            "$Key=$Value"
        } else {
            $line
        }
    }
    if (-not $updated) {
        $newLines += "$Key=$Value"
    }
    Set-Content -Path $Path -Value $newLines -Encoding UTF8
}

function New-ServerSecret {
    $bytes = New-Object byte[] 32
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $rng.GetBytes($bytes)
    } finally {
        $rng.Dispose()
    }
    return [Convert]::ToBase64String($bytes)
}

function Invoke-Step {
    param([string]$Title, [scriptblock]$Body)
    Write-Host ""
    Write-Host "== $Title ==" -ForegroundColor Cyan
    & $Body
}

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

Invoke-Step "Install local Python package" {
    if ($SkipInstall) {
        Write-Host "Skipped package install."
    } else {
        python -m pip install -e ".[test]"
    }
}

Invoke-Step "Create local sandbox server env" {
    Copy-Item ".env.server.example" ".env.server.local" -Force
    Set-EnvValue ".env.server.local" "DATABASE_URL" $DatabaseUrl
    Set-EnvValue ".env.server.local" "SERVER_PUBLIC_BASE_URL" "http://127.0.0.1:8000"
    Set-EnvValue ".env.server.local" "ARTIFACT_ROOT" $ArtifactRoot
    Set-EnvValue ".env.server.local" "SERVER_SECRET" (New-ServerSecret)
    Set-EnvValue ".env.server.local" "ALLOW_WORKER_REGISTRATION" "false"
    Set-EnvValue ".env.server.local" "TRUSTED_WORKER_IDS" $WorkerId
    Set-EnvValue ".env.server.local" "OLLAMA_BASE_URL" "http://127.0.0.1:11434"
    Set-EnvValue ".env.server.local" "OLLAMA_MODEL" $OllamaModel
}

Invoke-Step "Check local sandbox server config" {
    $env:CREATIVE_WORKFLOW_ENV_FILE = (Resolve-Path ".env.server.local").Path
    python -m creative_workflow.server.cli config check
}

Invoke-Step "Check local LLM" {
    if ($SkipLlmCheck) {
        Write-Host "Skipped local LLM check."
    } else {
        $env:CREATIVE_WORKFLOW_ENV_FILE = (Resolve-Path ".env.server.local").Path
        python -m creative_workflow.server.cli llm healthcheck
    }
}

Invoke-Step "Run database migration" {
    if ($SkipDbMigrate) {
        Write-Host "Skipped database migration."
    } else {
        $env:CREATIVE_WORKFLOW_ENV_FILE = (Resolve-Path ".env.server.local").Path
        python -m creative_workflow.server.cli db migrate
    }
}

Invoke-Step "Create local worker token and env" {
    $env:CREATIVE_WORKFLOW_ENV_FILE = (Resolve-Path ".env.server.local").Path
    $tokenOutput = python -m creative_workflow.server.cli worker-token create --worker-id $WorkerId
    $tokenLine = $tokenOutput | Where-Object { $_ -like "Worker token:*" } | Select-Object -First 1
    if (-not $tokenLine) {
        throw "Could not parse local worker token."
    }
    $token = $tokenLine.Substring("Worker token:".Length).Trim()

    Copy-Item ".env.worker.example" ".env.worker.local" -Force
    Set-EnvValue ".env.worker.local" "SERVER_BASE_URL" "http://127.0.0.1:8000"
    Set-EnvValue ".env.worker.local" "WORKER_ID" $WorkerId
    Set-EnvValue ".env.worker.local" "WORKER_TOKEN" $token
    Set-EnvValue ".env.worker.local" "WORKER_TEMP_ROOT" "D:/creative-workflow-local/worker-temp"
    Set-EnvValue ".env.worker.local" "PLAYWRIGHT_PROFILE_ROOT" "D:/creative-workflow-local/profiles"
    Set-EnvValue ".env.worker.local" "PLAYWRIGHT_BROWSER_CHANNEL" ""
    Set-EnvValue ".env.worker.local" "PLAYWRIGHT_CHROME_PROFILE_DIRECTORY" ""
    Set-EnvValue ".env.worker.local" "WORKER_CAPABILITIES" "browser.playwright,browser.gemini,browser.freepik"
    Write-Host "Created .env.worker.local for $WorkerId"
}

Invoke-Step "Install Playwright Chromium" {
    if ($SkipPlaywrightInstall) {
        Write-Host "Skipped Playwright browser install."
    } else {
        python -m playwright install chromium
    }
}

Invoke-Step "Create local sandbox shortcuts" {
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\create_local_sandbox_shortcuts.ps1"
}

Write-Host ""
Write-Host "Local sandbox setup is ready." -ForegroundColor Green
Write-Host "Start all local processes with:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\start_local_sandbox.ps1"
