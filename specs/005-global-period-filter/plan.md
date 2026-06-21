# Implementation Plan: Selector de Período Global en Navegación

**Branch**: `005-global-period-filter` | **Date**: 2026-06-21 | **Spec**: [spec.md](spec.md)

## Summary

Move the `YearMonthSelector` component from within the Expenses and Incomes pages into the shared `+layout.svelte` AppRail sidebar. Update the General page server load to read `year`/`month` from URL params. Remove embedded selectors from Expenses and Incomes pages. No backend changes required — the filtering API was implemented in feature 004.

## Technical Context

**Language/Version**: TypeScript 5 / Svelte 5 (runes + legacy slots compatibility mode)
**Primary Dependencies**: SvelteKit 2, `$app/navigation` (goto), `$app/state` (page), Svelte writable stores
**Storage**: N/A (stateless URL params for period propagation)
**Testing**: `npm run check` (type check), manual browser verification
**Target Platform**: Web browser (SvelteKit SSR + client hydration)
**Project Type**: Web application frontend (monorepo subproject: `kakebo-front/`)
**Constraints**: Must work with existing SvelteKit SSR load functions; period must survive navigation via URL params

## Project Structure

### Documentation (this feature)

```text
specs/005-global-period-filter/
├── plan.md              # This file
├── spec.md              # Feature specification
├── tasks.md             # Task list
└── checklists/
    └── requirements.md
```

### Source Code (modified files only)

```text
kakebo-front/src/
├── routes/+layout.svelte              ← Add YearMonthSelector to AppRail
├── routes/+page.server.ts             ← Add year/month URL param reading
├── routes/+page.svelte                ← Dynamic month/year in heading
├── routes/expenses/+page.svelte       ← Remove embedded YearMonthSelector
└── routes/incomes/+page.svelte        ← Remove embedded YearMonthSelector

# Unchanged (already correct from feature 004):
kakebo-front/src/routes/expenses/+page.server.ts
kakebo-front/src/routes/incomes/+page.server.ts
kakebo-front/src/lib/components/filters/YearMonthSelector.svelte
kakebo-front/src/lib/stores.ts
```

## Key Design Decisions

1. **URL params as the source of truth**: Period is propagated via `?year=Y&month=M` in the URL. This makes pages SSR-compatible, bookmarkable, and shareable.
2. **Layout reads `page.url.searchParams`**: `+layout.svelte` already imports `page` from `$app/state`. The active year/month are derived reactively from the URL.
3. **`goto(pathname + '?year=Y&month=M')`**: When the user selects a period, the layout navigates to the same pathname with the new params, triggering page server loads.
4. **No `+layout.server.ts` needed**: Each page's own `+page.server.ts` reads URL params independently. No shared server-side period load is required.
