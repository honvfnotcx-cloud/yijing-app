# Yijing API

NestJS-style API for the first release of the daily reflection app. It currently uses in-memory stores so the mobile client can be built and tested before PostgreSQL, a queue, and store verification are connected.

## Run locally

```powershell
pnpm install
pnpm run build
pnpm start
```

The server listens on `http://localhost:3000/v1`. Start with `POST /v1/profiles`, then request `GET /v1/profiles/:profileId/daily-guidance`.

## Included domains

- Personal profiles and privacy-aware birth data fields
- Versioned, deterministic daily reflection guidance
- Evening reflections
- Moderated community posts, comments, reports, and blocks
- Local-time notification preferences (scheduling is intentionally a future worker concern)
- Store billing product and checkout-intent placeholders (no payment is charged by this service)

## Production follow-ups

Replace the in-memory maps with PostgreSQL repositories, authenticate every profile-scoped request, encrypt birth/reflection data at rest, add a time-zone-aware notification worker, and verify Apple/Google purchase tokens server-side before granting entitlements.
