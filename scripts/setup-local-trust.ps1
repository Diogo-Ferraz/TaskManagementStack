param(
    [string]$ContainerName = "tm-caddy",
    [string]$CertOutputPath = "$env:TEMP\caddy-local-root.crt"
)

$ErrorActionPreference = "Stop"

function Ensure-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found in PATH."
    }
}

Ensure-Command docker
Ensure-Command certutil

Write-Host "Ensuring Caddy container is running..."
$running = docker ps --format '{{.Names}}' | Select-String -SimpleMatch $ContainerName
if (-not $running) {
    Write-Host "Container '$ContainerName' is not running. Start stack first:"
    Write-Host "  docker compose up -d --pull always"
    exit 1
}

Write-Host "Exporting Caddy local root certificate..."
docker cp "$ContainerName`:/data/caddy/pki/authorities/local/root.crt" "$CertOutputPath"

Write-Host "Installing certificate into Windows Trusted Root Certification Authorities..."
certutil -addstore -f "Root" "$CertOutputPath" | Out-Null

Write-Host "Certificate installed successfully."
Write-Host "Restart your browser and open:"
Write-Host "  https://app.localhost"
Write-Host "  https://api.localhost/health"
Write-Host "  https://auth.localhost"
