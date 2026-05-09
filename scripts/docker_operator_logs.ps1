param(
    [string]$Service = ""
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

if ($Service) {
    docker compose -f docker-compose.operator.yml --env-file .env.docker logs -f --tail 100 $Service
} else {
    docker compose -f docker-compose.operator.yml --env-file .env.docker logs -f --tail 100
}
