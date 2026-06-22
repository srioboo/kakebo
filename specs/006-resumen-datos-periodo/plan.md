# Implementation Plan: Resumen con Datos Reales por Período

**Branch**: `006-resumen-datos-periodo` | **Date**: 2026-06-22 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/006-resumen-datos-periodo/spec.md`

## Summary

Move metric computation (total ingresos, total gastos, ahorro, tasa de ahorro) from the Svelte component into `+page.server.ts` so all derived values arrive pre-calculated in `data`. This removes the root-cause bug where `const` declarations in `+page.svelte` were evaluated once at mount and never re-computed when SvelteKit re-ran the server load after a period change. The page component is then reduced to a pure render layer that reactively reflects whatever the server sends.

## Technical Context

**Language/Version**: TypeScript 5.x / Svelte 5 (runes) + Svelte 4 legacy syntax  
**Primary Dependencies**: SvelteKit 2, Vite 6, TailwindCSS 4  
**Storage**: N/A — reads from existing REST API via `src/lib/api.ts`  
**Testing**: Vitest (unit), Playwright (e2e)  
**Target Platform**: Browser (SvelteKit SSR + client hydration)  
**Project Type**: Web application — frontend only  
**Performance Goals**: Data refresh on period change in a single navigation cycle  
**Constraints**: No new backend endpoints; no new npm dependencies; `$app/state` for reactive navigation state  
**Scale/Scope**: Single route (`/resumen`); touches 1 server load file and 1 page component

## Constitution Check

| Principle | Status | Notes |
|-----------|--------|-------|
| Repository Boundaries | PASS | Frontend-only change; no cross-subproject drift |
| Hexagonal Backend Ownership | PASS | No backend changes; existing endpoints unchanged |
| Contract-Aligned Frontend | PASS | Existing `src/lib/api.ts` functions reused; `+page.server.ts` stays as SSR loader |
| Verify Before Merge | PASS | Must run `npm run check` and `npm run lint` in `kakebo-front/` before merging |
| Generated Artifacts & Localization | PASS | No Paraglide-generated files touched; any new user-facing label TBD via messages |

No gate violations. Complexity tracking not required.

## Project Structure

### Documentation (this feature)

```text
specs/006-resumen-datos-periodo/
├── plan.md              ← this file
├── research.md          ← Phase 0 output
├── data-model.md        ← Phase 1 output
└── tasks.md             ← Phase 2 output (/speckit.tasks)
```

No `/contracts/` directory — feature introduces no new public interface; existing backend REST contract is unchanged.

### Source Code (repository root)

```text
kakebo-front/
└── src/
    └── routes/
        └── resumen/
            ├── +page.server.ts   ← ADD computed totals; return pre-calculated ResumenPageData
            └── +page.svelte      ← REWRITE: remove const derivations; render data.* directly; add skeleton
```

**Structure Decision**: Single-subproject frontend change. Only two files change. No new components, no new API functions, no new routes.

## Implementation Notes

### Root-cause fix (FR-011)

`+page.server.ts` already fetches both expense and income arrays. The change adds the four aggregation calculations before the `return` statement:

```ts
const totalIncome = incomes.reduce((s, i) => s + i.amount, 0);
const totalExpenses = expenses.reduce((s, e) => s + e.amount, 0);
const savings = totalIncome - totalExpenses;
const savingsRate = totalIncome === 0 ? 0 : Math.round((savings / totalIncome) * 1000) / 10;
const monthName = new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(new Date(year, month - 1));
```

Return shape: `{ year, month, monthName, totalIncome, totalExpenses, savings, savingsRate, error? }` — raw arrays are dropped from the return value since the page no longer needs them.

### Skeleton loading state (NFR-004)

`navigating` from `$app/state` is `null` when idle and a `Navigation` object during any SvelteKit navigation. Use it to swap the four metric cards for skeleton placeholders:

```svelte
<script>
  import { navigating } from '$app/state';
  export let data;
</script>

{#if navigating}
  <!-- four skeleton cards with animate-pulse -->
{:else}
  <!-- real metric cards using data.totalIncome etc. -->
{/if}
```

Skeleton cards mirror the same `kakebo-surface rounded-xl p-4` layout as the real cards.

### Heading (FR-010)

The heading string is assembled in the template from `data.monthName` and `data.year`:

```svelte
<h1>Resumen mensual · {data.monthName.charAt(0).toUpperCase()}{data.monthName.slice(1)} {data.year}</h1>
```

`monthName` is computed server-side so the heading is always consistent with the displayed metrics.

### Error banner (FR-009)

Already implemented in the current `+page.svelte`; the inline banner pattern (`data.error`) is preserved unchanged.

## Complexity Tracking

No constitution violations. Table not required.
