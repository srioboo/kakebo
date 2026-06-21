# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Kakebo is a personal finance management app (Japanese kakebo budgeting method) built as a monorepo with three subprojects. **There is no root-level build**: always `cd` into the relevant subproject before running commands.

- `kakebo-backend/` — Spring Boot 4 REST API (Java 21)
- `kakebo-front/` — SvelteKit 2 + Svelte 5 UI
- `kakebo-admin/` — Separate SvelteKit admin dashboard

## Backend (`kakebo-backend/`)

### Commands
```bash
make start                      # ./mvnw spring-boot:run (prod profile, PostgreSQL)
./mvnw spring-boot:run -Dspring.profiles.active=dev   # H2 in-memory, no Docker needed
make test                       # Run all tests
./mvnw test -Dtest=ClassName    # Run a single test class
make build                      # Package JAR (target/kakebo-*.jar)
make coverage                   # JaCoCo report → target/site/jacoco/index.html
make lint                       # SonarQube local analysis + coverage
```

Dev URLs: `http://localhost:9090/swagger-ui.html`, `http://localhost:9090/h2-console`

### Architecture

Hexagonal (ports & adapters) organized by domain:
```
expenses/
  domain/model/         → JPA entity (Expenses)
  domain/repository/    → CrudRepository interface
  application/service/  → Business logic (@Service)
  infrastructure/rest/  → REST controller
income/                 → Mirrors expenses/ structure
```

- `update*()` methods do partial patch: only non-null fields are overwritten
- `GET /{id}` returns an empty entity (not 404) when the record doesn't exist
- Both `Expenses` and `Incomes` **must** implement `equals()` and `hashCode()` — tests break without them even if values match

### Database profiles

| Profile | Database | DDL |
|---------|----------|-----|
| `dev` | H2 in-memory | `update` (auto-creates tables) |
| `prod` | PostgreSQL (port 52010 via Docker) | `validate` + Flyway migrations |

Flyway migrations live in `src/main/resources/db/migration/` (`V{n}__{description}.sql`). Only runs in `prod`.

### Testing patterns

Spring Boot 4 removed `TestRestTemplate` auto-registration. Use plain `RestTemplate` instantiated locally:

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class MyTest {
    @LocalServerPort private int port;
    private final RestTemplate restTemplate = new RestTemplate();
    // ...
}
```

Parse JSON responses with `DocumentContext` (JsonPath) + AssertJ assertions.

### Adding a new endpoint

1. Service method → Controller `@RestMapping` with `@Operation` Swagger annotation
2. Ensure `@CrossOrigin(origins = "https://localhost:5173")` is on the controller
3. Add REST test using the `RestTemplate` + `@LocalServerPort` pattern
4. Update `kakebo-front/src/lib/api.ts` and `+page.server.ts`

## Frontend (`kakebo-front/`)

### Commands
```bash
npm run dev            # Vite dev server on port 5173
npm run check          # TypeScript + Svelte type check
npm run lint           # Prettier check + ESLint
npm run format         # Auto-format (tabs, single quotes, no trailing commas)
npm run test:unit      # Vitest
npm run test:e2e       # Playwright (builds + previews first)
npm run build          # Production build
```

**Known issue (April 2026)**: `npm run test:unit` fails in `src/routes/page.svelte.test.ts` due to `@apply inside @keyframes` with Tailwind v4. Validate PostCSS/Tailwind compilation before touching UI tests.

### Architecture

- **API boundary**: `src/lib/api.ts` — all backend calls go here, reads `VITE_API_BASE_URL` from `.env.local`
- **SSR data load**: `src/routes/+page.server.ts` → calls `api.ts` → returns `{ expenses, incomes }` or `{ error }`
- **Page shape**: `+page.svelte` consumes `incomes?.data` and `expenses?.data` — maintain this shape when changing fetch/load/UI
- **Layout shell**: `src/routes/+layout.svelte` with `AppShell/AppBar/AppRail*` components from `src/lib/components/layout/`
- **i18n**: Paraglide with Spanish as source language (`messages/es.json` → `messages/en.json`). Never edit `src/lib/paraglide/` — it's generated and git-ignored. Hooks wired in `src/hooks.server.ts` and `src/hooks.ts`.

Adding new endpoints: extend `src/lib/api.ts`, then connect in `+page.server.ts` — no direct fetch from page components.

## Conventions

- **Commits**: Conventional Commits format enforced by commitlint + Husky pre-commit hooks
- **Java**: Constructor injection preferred; Lombok `@Data` on entities (requires annotation processing in Maven compiler)
- **TypeScript/JS**: `allowJs` + `checkJs` enabled — JS files are also type-checked
- **Formatting**: Tabs, single quotes, no trailing commas (`.prettierrc`)

## Key references

- `AGENTS.md` (root, backend, frontend) — detailed guidance per subproject
- `docs/api-contract.md` — canonical REST API specification
- `kakebo-backend/docs/00_INDEX.md` — backend documentation index
- `kakebo-backend/docs/08_SOLUCION_EQUALS_HASHCODE.md` — entity comparison patterns
- `specs/` — feature specifications by number