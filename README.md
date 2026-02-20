# TaskManagementStack

Orchestration repo for running the full Task Management stack with one command.

This repo is intentionally separate from:
- `TaskManagementServer` (backend source)
- `TaskManagementClient` (frontend source)

## What this runs

- SQL Server
- Auth service (.NET / OpenIddict)
- API service (.NET)
- Angular SPA client
- Caddy reverse proxy (single HTTPS entrypoint)

## Hostnames

- [https://app.localhost](https://app.localhost) - SPA
- [https://api.localhost](https://api.localhost) - API
- [https://auth.localhost](https://auth.localhost) - Auth

## Prerequisites

- Docker Desktop (or Docker Engine + Compose plugin)
- Ports `80` and `443` available

## Quick start

1. Copy env file:

```bash
cp .env.example .env
```

2. Update image tags in `.env` if you want to pin a specific version.

3. Start stack:

```bash
docker compose up -d --pull always
```

4. Open [https://app.localhost](https://app.localhost)

5. Login with one of the default users:

- `demo-admin@example.com`
- `demo-manager@example.com`
- `demo-user@example.com`

Password is `DEMO_PASSWORD` from your `.env`.

## Architecture Notes

- Services are independent containers connected through Docker network.
- Caddy acts as the only edge reverse proxy.
- SPA uses OpenID Connect Authorization Code + PKCE via auth service.
- API is protected and validated against OpenIddict issuer.

## Recommended release flow

- Frontend repo CI builds and pushes `taskmanagement-client` image.
- Backend repo CI builds and pushes `taskmanagement-api` and `taskmanagement-auth` images.
- This stack repo only updates image tags for release versions.

## Troubleshooting

- If `*.localhost` cert trust warning appears first time, accept local cert trust prompt from browser or Caddy local CA tooling.
- Check status:

```bash
docker compose ps
```

- Inspect logs:

```bash
docker compose logs -f caddy auth-service api-service client
```
