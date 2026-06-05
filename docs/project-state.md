# Project State

Current repository overview (snapshot):

- Subprojects:
  - `kakebo-backend/` — Spring Boot backend (Expenses, Incomes domains).
  - `kakebo-front/` — SvelteKit frontend that consumes the backend API.
  - `kakebo-admin/` — Separate admin project (out of scope for this wiki unless noted).

Active areas:

- Backend: REST endpoints for `/expenses` and `/incomes`.
- Frontend: SSR pages and UI under `kakebo-front/src/routes/` consuming the API.

Boundaries and notes:

- The admin project is maintained separately; cross-project changes must be
  coordinated and documented here when they affect more than one subproject.
- Generated files (e.g., `src/lib/paraglide/`) are read-only; regenerate via
  toolchain.

Where to look for details:

- Backend docs: `kakebo-backend/docs/00_INDEX.md`
- Frontend README: `kakebo-front/README.md`

