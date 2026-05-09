param(
    [switch]$Volumes
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

$args = @("compose", "-f", "docker-compose.operator.yml", "--env-file", ".env.docker", "down")
if ($Volumes) {
    $args += "--volumes"
}

docker @args
