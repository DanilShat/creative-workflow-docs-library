param(
    [string]$WorkerId = "designer-laptop-01"
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

docker compose -f docker-compose.operator.yml --env-file .env.docker exec api python -m creative_workflow.server.cli worker-token create --worker-id $WorkerId
