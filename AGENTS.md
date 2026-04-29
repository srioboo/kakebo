# AGENTS.md - Kakebo repo root

## Alcance
- Este repositorio coordina tres subproyectos: `kakebo-backend/` (API Spring Boot), `kakebo-front/` (UI SvelteKit) y `kakebo-admin/` (proyecto aparte).
- No hay build único en la raíz; trabaja en el subproyecto que toque.

## Lee primero
- Backend: `kakebo-backend/AGENTS.md`, `kakebo-backend/README.md`, `kakebo-backend/docs/00_INDEX.md`.
- Frontend: `kakebo-front/AGENTS.md`, `kakebo-front/README.md`, `kakebo-front/src/routes/+layout.svelte`, `kakebo-front/src/routes/+page.server.js`, `kakebo-front/src/lib/api.js`.

## Arquitectura que importa
- Backend hexagonal por dominio: `expenses/` e `income/` separan `domain/model`, `domain/repository`, `application/service` e `infrastructure/rest`.
- Los controladores exponen `/expenses` y `/incomes`, usan inyección por constructor y anotaciones Swagger (`@Operation`, `@Parameter`).
- Los `update*()` hacen parche parcial: solo sobrescriben campos no nulos; los `GET /{id}` devuelven entidad vacía cuando no hay registro.

## Datos, configuración e integración
- `kakebo-backend/src/main/resources/application-dev.properties` usa H2; `application-prod.properties` usa PostgreSQL + Flyway; el puerto HTTP es `9090`.
- La UI consume el backend vía `VITE_API_BASE_URL` en `kakebo-front/src/lib/api.js` (`/expenses` y `/incomes`); `+page.server.js` centraliza el fetch SSR.
- Paraglide se activa en `kakebo-front/src/hooks.server.ts` y `kakebo-front/src/hooks.ts`; no edites `kakebo-front/src/lib/paraglide/` a mano.

## Convenciones del repo
- Backend: `Expenses` e `Incomes` implementan `equals()`/`hashCode()`; las pruebas REST usan `RestTemplate` con `@LocalServerPort`.
- Frontend: mezcla JS y TS, usa tabs y comillas simples; el layout común vive en `src/lib/components/layout/` (`AppShell`, `AppBar`, `AppRail`).
- En `src/routes/+page.svelte`, los datos esperados siguen la forma `{ expenses, incomes }` y luego `expenses?.data` / `incomes?.data`.

## Flujos de trabajo útiles
- Backend: `make start`, `make test`, `make coverage`, `make lint` o `./mvnw spring-boot:run -Dspring.profiles.active=dev`.
- Frontend: `bun run dev`, `bun run check`, `bun run lint`, `bun run test:unit`, `bun run test:e2e`.
- Al añadir endpoints backend, actualiza primero el servicio/controlador y luego `kakebo-front/src/lib/api.js` + `+page.server.js`.

