param(
    [string]$ServerBaseUrl = "",
    [string]$DatabaseUrl = "postgresql+psycopg://creative:creative@localhost:5432/creative_workflow",
    [string]$ArtifactRoot = "D:/creative-workflow/artifacts",
    [string]$OllamaModel = "gemma3n:e2b",
    [string]$WorkerId = "designer-laptop-01",
    [switch]$SkipInstall,
    [switch]$SkipDbMigrate,
    [switch]$SkipLlmCheck
)

$ErrorActionPreference = "Stop"

function Resolve-LanServerBaseUrl {
    $candidate = Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object {
            $_.IPAddress -notlike "127.*" -and
            $_.IPAddress -notlike "169.254.*" -and
            $_.PrefixOrigin -ne "WellKnown"
        } |
        Select-Object -First 1 -ExpandProperty IPAddress
    if (-not $candidate) {
        $candidate = "127.0.0.1"
    }
    return "http://$candidate`:8000"
}

function Set-EnvValue {
    param(
        [string]$Path,
        [string]$Key,
        [string]$Value
    )
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

function Get-EnvValue {
    param(
        [string]$Path,
        [string]$Key
    )
    if (-not (Test-Path $Path)) {
        return ""
    }
    $pattern = "^$([regex]::Escape($Key))=(.*)$"
    $line = Get-Content -Path $Path | Where-Object { $_ -match $pattern } | Select-Object -First 1
    if (-not $line) {
        return ""
    }
    return ($line -replace $pattern, '$1').Trim()
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
    param(
        [string]$Title,
        [scriptblock]$Body
    )
    Write-Host ""
    Write-Host "== $Title ==" -ForegroundColor Cyan
    & $Body
}

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

if (-not $ServerBaseUrl) {
    $ServerBaseUrl = Resolve-LanServerBaseUrl
}

Invoke-Step "Install Python package on operator laptop" {
    if ($SkipInstall) {
        Write-Host "Skipped install because -SkipInstall was provided."
    } else {
        python -m pip install -e ".[test]"
    }
}

Invoke-Step "Create operator .env.server" {
    if (-not (Test-Path ".env.server")) {
        Copy-Item ".env.server.example" ".env.server"
    }
    Set-EnvValue ".env.server" "DATABASE_URL" $DatabaseUrl
    Set-EnvValue ".env.server" "SERVER_PUBLIC_BASE_URL" $ServerBaseUrl
    Set-EnvValue ".env.server" "ARTIFACT_ROOT" $ArtifactRoot
    $existingSecret = Get-EnvValue ".env.server" "SERVER_SECRET"
    if (-not $existingSecret -or $existingSecret -like "change-me*") {
        Set-EnvValue ".env.server" "SERVER_SECRET" (New-ServerSecret)
        Write-Host "Generated a new SERVER_SECRET for this operator install."
    } else {
        Write-Host "Preserved existing SERVER_SECRET so current worker-token hashes remain valid."
    }
    Set-EnvValue ".env.server" "ALLOW_WORKER_REGISTRATION" "false"
    Set-EnvValue ".env.server" "TRUSTED_WORKER_IDS" $WorkerId
    Set-EnvValue ".env.server" "OLLAMA_BASE_URL" "http://127.0.0.1:11434"
    Set-EnvValue ".env.server" "OLLAMA_MODEL" $OllamaModel
    Write-Host "Wrote .env.server with SERVER_PUBLIC_BASE_URL=$ServerBaseUrl"
}

Invoke-Step "Check server configuration" {
    python -m creative_workflow.server.cli config check
}

Invoke-Step "Check local LLM" {
    if ($SkipLlmCheck) {
        Write-Host "Skipped local LLM check because -SkipLlmCheck was provided."
    } else {
        python -m creative_workflow.server.cli llm healthcheck
    }
}

Invoke-Step "Run database migration" {
    if ($SkipDbMigrate) {
        Write-Host "Skipped database migration because -SkipDbMigrate was provided."
    } else {
        python -m creative_workflow.server.cli db migrate
    }
}

Invoke-Step "Create worker token" {
    $tokenOutput = python -m creative_workflow.server.cli worker-token create --worker-id $WorkerId
    $tokenOutput | ForEach-Object { Write-Host $_ }
    $tokenLine = $tokenOutput | Where-Object { $_ -like "Worker token:*" } | Select-Object -First 1
    if (-not $tokenLine) {
        throw "Could not parse worker token from server output."
    }
    $script:WorkerToken = $tokenLine.Substring("Worker token:".Length).Trim()
}

Invoke-Step "Build designer laptop archive" {
    $dist = Join-Path $RepoRoot "dist"
    $packageRoot = Join-Path $dist "designer_worker_package"
    $archivePath = Join-Path $dist "designer_worker_package.zip"
    if (Test-Path $packageRoot) {
        Remove-Item -LiteralPath $packageRoot -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $packageRoot | Out-Null

    $items = @(
        "src",
        "scripts",
        "runtime_docs",
        "pyproject.toml",
        "README.md",
        ".env.worker.example"
    )
    foreach ($item in $items) {
        Copy-Item -Path (Join-Path $RepoRoot $item) -Destination $packageRoot -Recurse -Force
    }

    Copy-Item -Path (Join-Path $RepoRoot "scripts\setup_designer_one_click.ps1") -Destination (Join-Path $packageRoot "setup_designer_one_click.ps1") -Force
    Copy-Item -Path (Join-Path $RepoRoot "runtime_docs\designer_laptop_setup.md") -Destination (Join-Path $packageRoot "READ_ME_DESIGNER_SETUP.md") -Force

    Copy-Item -Path (Join-Path $RepoRoot ".env.worker.example") -Destination (Join-Path $packageRoot ".env.worker") -Force
    Set-EnvValue (Join-Path $packageRoot ".env.worker") "SERVER_BASE_URL" $ServerBaseUrl
    Set-EnvValue (Join-Path $packageRoot ".env.worker") "WORKER_ID" $WorkerId
    Set-EnvValue (Join-Path $packageRoot ".env.worker") "WORKER_TOKEN" $script:WorkerToken

    if (Test-Path $archivePath) {
        Remove-Item -LiteralPath $archivePath -Force
    }
    Compress-Archive -Path (Join-Path $packageRoot "*") -DestinationPath $archivePath -Force
    Write-Host "Created designer package: $archivePath"
}

Write-Host ""
Write-Host "Operator setup is prepared." -ForegroundColor Green
Write-Host "Next on this laptop:"
Write-Host "  python -m creative_workflow.server.cli dev --host 0.0.0.0 --port 8000"
Write-Host "  python -m creative_workflow.server.cli ui --port 8501"
Write-Host ""
Write-Host "Copy this archive to the designer laptop:"
Write-Host "  dist\designer_worker_package.zip"
