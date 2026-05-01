# AGENTS.md

## Contexto rapido
- Stack: SvelteKit 2 + Svelte 5 + Vite 6 + TailwindCSS 4 + Paraglide (i18n).
- Objetivo actual del repo: frontend de Kakebo con vistas base (`/`, `/diario`, `/resumen`, `/ayuda`) y consumo de API externa.
- Fuente de convenciones existente: `README.md` (plantilla Svelte con notas de npm/bun).

## Mapa de arquitectura (leer primero)
- Shell global y navegacion: `src/routes/+layout.svelte`.
- Punto de entrada HTML con placeholders i18n: `src/app.html` (`%paraglide.lang%`, `%paraglide.textDirection%`).
- Home SSR + carga de datos: `src/routes/+page.server.ts` -> `src/lib/api.ts` -> render en `src/routes/+page.svelte`.
- Rutas secundarias simples: `src/routes/diario/+page.svelte`, `src/routes/resumen/+page.svelte`, `src/routes/ayuda/+page.svelte`.
- Demo de cambio de idioma en cliente: `src/routes/demo/paraglide/+page.svelte`.

## Flujo de datos y limites
- Limite Frontend/API: `src/lib/api.ts` usa `import.meta.env.VITE_API_BASE_URL` y llama `/incomes` y `/expenses`.
- El `load()` server-side de `src/routes/+page.server.ts` devuelve `{ expenses, incomes }` o `{ error }`.
- `src/routes/+page.svelte` consume `incomes?.data` y `expenses?.data`; mantén esta forma al tocar fetch/load/UI.
- Si agregas nuevos endpoints, extiende `src/lib/api.ts` y luego conecta en `+page.server.ts` (no fetch directo desde la vista principal).

## i18n y rutas localizadas (Paraglide)
- Config i18n: `project.inlang/settings.json` con `sourceLanguageTag: "es"` y `languageTags: ["es", "en"]`.
- Hook server: `src/hooks.server.ts` (`i18n.handle()`), rerouting: `src/hooks.ts` (`i18n.reroute()`).
- Runtime y mensajes generados en `src/lib/paraglide/` (ignorado por git); no edites a mano los archivos generados.
- Mensajes fuente: `messages/es.json` y `messages/en.json`.

## Workflows de desarrollo
- Dev server: `npm run dev` (alternativa disponible en README: `bun run dev`).
- Calidad estatica: `npm run check`, `npm run lint`, `npm run format`.
- Unit tests: `npm run test:unit` (Vitest workspace cliente/servidor en `vite.config.ts`).
- E2E: `npm run test:e2e` (Playwright levanta `npm run build && npm run preview`, config en `playwright.config.ts`).

## Estado de pruebas observado (abril 2026)
- `npm run test:unit -- --run` falla en `src/routes/page.svelte.test.ts` por CSS de `src/routes/+page.svelte`:
  `You cannot use @apply inside @keyframes` (Tailwind v4).
- Al trabajar en tests de UI, valida primero compilacion de estilos PostCSS/Tailwind de la ruta objetivo.

## Convenciones especificas del repo
- Formato: tabs + comilla simple + sin trailing commas (`.prettierrc`).
- JS en runtime y TS mixto: `allowJs` + `checkJs` activados (`tsconfig.json`), asi que cambios JS tambien se chequean.
- En Svelte, el layout usa componentes `AppShell/AppBar/AppRail*`; verifica disponibilidad antes de refactors grandes del layout.
- `src/lib/paraglide` esta en `.gitignore`; si falta, regeneralo via toolchain de Vite/Paraglide al correr el proyecto.

## Integraciones externas
- API backend via `VITE_API_BASE_URL` (variable requerida para datos reales de ingresos/gastos).
- Paraglide se integra como plugin Vite (`vite.config.ts`, `paraglide({ project, outdir })`).
- TailwindCSS v4 via plugin de Vite (`@tailwindcss/vite`) y `@import 'tailwindcss';` en `src/app.css`.
