# TaskManagementStack

Deployment and orchestration repository for the full Task Management platform.

This repository runs the deployed stack for:
- Client: [TaskManagementClient](https://github.com/Diogo-Ferraz/TaskManagementClient)
- Server: [TaskManagementServer](https://github.com/Diogo-Ferraz/TaskManagementServer)

## Live Website

- App: [https://app.144.24.250.76.nip.io/](https://app.144.24.250.76.nip.io/)

## Demo Accounts

- `demo-admin@example.com` - `Administrator` role
- `demo-manager@example.com` - `ProjectManager` role
- `demo-user@example.com` - `User` role

Password for all accounts:
- `Demo123!`

Each account has role-specific access and permissions in the UI and API.

## What this runs

- PostgreSQL
- Auth service (.NET / OpenIddict)
- API service (.NET)
- Angular SPA client
- Caddy reverse proxy (single HTTPS entrypoint)

## Local Hostnames

- [https://app.localhost](https://app.localhost) - SPA
- [https://api.localhost](https://api.localhost) - API
- [https://auth.localhost](https://auth.localhost) - Auth

## Prerequisites

- Docker Desktop (or Docker Engine + Compose plugin)
- Ports `80` and `443` available

## Local Setup

1. Copy environment file:

```bash
cp .env.example .env.local
```

2. Start stack with local overlay:

```bash
./scripts/up-local.sh
```

3. Trust Caddy local certificate (one-time setup):

macOS:

```bash
./scripts/setup-local-trust.sh
```

Windows (PowerShell as Administrator):

```powershell
./scripts/setup-local-trust.ps1
```

4. Open [https://app.localhost](https://app.localhost)

5. Login with one of the demo accounts listed above.

## Architecture Notes

- Services are independent containers connected through Docker network.
- Caddy acts as the edge reverse proxy.
- SPA uses OpenID Connect Authorization Code + PKCE via auth service.
- API is protected and validated against OpenIddict issuer.

## Recommended release flow

- Frontend repo CI builds and pushes `taskmanagement-client` images.
- Backend repo CI builds and pushes `taskmanagement-api` and `taskmanagement-auth` images.
- This stack repo only updates image tags and environment files for release versions.

## Troubleshooting

- Check status:

```bash
docker compose --env-file .env.local -f docker-compose.yml -f docker-compose.local.yml ps
```

- Inspect logs:

```bash
docker compose --env-file .env.local -f docker-compose.yml -f docker-compose.local.yml logs -f caddy auth-service api-service client
```
