# Tasks: Selector de Período Global en Navegación

**Input**: Design documents from `/specs/005-global-period-filter/`
**Prerequisites**: spec.md (user stories), plan.md (tech context), clarification 2026-06-21

**Context from feature 004**: Year/month filtering is already implemented in the backend (`GET /expenses?year=Y&month=M`, `GET /incomes?year=Y&month=M`). The `YearMonthSelector.svelte` component and `selectedPeriod` store already exist.

**Organization**: Tasks grouped by user story. Phases 1–6 are complete (original implementation). Phase 7 adds tasks from the clarification session (2026-06-21): show selected month in the "Resumen mensual" section inside General and in the `/resumen` page heading.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Exact file paths included in all descriptions

## Path Conventions

```text
kakebo-front/src/
├── routes/+layout.svelte              ← global selector (done)
├── routes/+page.server.ts             ← General: reads year/month from URL (done)
├── routes/+page.svelte                ← General: dynamic heading + Resumen mensual section
├── routes/resumen/+page.server.ts     ← NEW: read year/month from URL
├── routes/resumen/+page.svelte        ← NEW: dynamic heading
├── routes/expenses/+page.svelte       ← embedded selector removed (done)
├── routes/incomes/+page.svelte        ← embedded selector removed (done)
├── lib/stores.ts                      ← selectedPeriod store (done)
└── lib/components/filters/
    └── YearMonthSelector.svelte       ← already exists (feature 004)
```

---

## Phase 1: Setup (Verificación)

**Purpose**: Confirm the feature 004 foundation is in place before making layout changes

- [x] T001 Verify `kakebo-front/src/lib/components/filters/YearMonthSelector.svelte` exists (created in feature 004)
- [x] T002 [P] Verify `kakebo-front/src/lib/stores.ts` exports `selectedPeriod` writable store (added in feature 004)

---

## Phase 2: Foundational (Selector Global en Layout)

**Purpose**: Add the period selector to the shared layout — BLOCKS US2 and US3 which depend on it being in the layout

- [x] T003 Update `kakebo-front/src/routes/+layout.svelte`: import `YearMonthSelector` from `$lib/components/filters`; import `goto` from `$app/navigation`; derive `activeYear` and `activeMonth` from `page.url.searchParams` (defaulting to current date values when absent); add a `handlePeriodSelect` function that calls `goto(page.url.pathname + '?year=${year}&month=${month}')`
- [x] T004 Update `kakebo-front/src/routes/+layout.svelte`: add `YearMonthSelector` component inside the AppRail default slot (below the last `AppRailAnchor` nav item, before the trail slot); pass `currentYear={activeYear}` and `currentMonth={activeMonth}` props; wire `on:select={handlePeriodSelect}`; add a visual section label "Período" above the selector

**Checkpoint**: Reload any app page — the sidebar shows the YearMonthSelector with the current month highlighted. Clicking a different month updates the URL params (`?year=Y&month=M`) and the selector highlight updates.

---

## Phase 3: User Story 1 - Selector global visible en todo momento (Priority: P1) 🎯 MVP

**Goal**: The YearMonthSelector is always visible in the AppRail sidebar from any screen in the app.

**Independent Test**: Navigate to `/`, `/diario`, `/expenses`, `/incomes`, `/resumen` — the sidebar shows the period selector at all times with the active period highlighted.

- [x] T005 [US1] Verify `kakebo-front/src/routes/+layout.svelte` correctly derives active year/month: when URL has `?year=2020&month=1`, the selector highlights January 2020; when URL has no params, it highlights the current month/year
- [x] T006 [US1] Verify the `YearMonthSelector` label in the AppRail does not overlap or hide any navigation anchors (General, Diario, Gastos, Ingresos, Resumen, Ayuda) on typical viewport sizes; adjust padding/spacing if needed

**Checkpoint**: US1 fully testable independently — the global selector is always present and reflects the URL state.

---

## Phase 4: User Story 2 - Período aplicado a todas las pantallas con datos (Priority: P1)

**Goal**: Selecting a period in the global selector causes General, Expenses, and Incomes pages to show only data from that period.

**Independent Test**: Select January 2020 in the sidebar selector from the General page — General shows incomes and expenses from January 2020 only. Navigate to Gastos — same. Navigate to Ingresos — same.

- [x] T007 [US2] Update `kakebo-front/src/routes/+page.server.ts` (General): change `load()` to `load({ url })`, read `year` and `month` from `url.searchParams` defaulting to current date values, then call `getExpenses(year, month)` and `getIncomes(year, month)`; return `{ expenses, incomes, year, month }`
- [x] T008 [US2] Update `kakebo-front/src/routes/+page.svelte` (General): replace hardcoded `new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(new Date())` with a dynamic month/year label built from `data.year` and `data.month`; update the "Portada mensual" heading to show the selected period (e.g., "Kakebo · Junio 2026")
- [x] T009 [US2] Verify `kakebo-front/src/routes/expenses/+page.server.ts` and `incomes/+page.server.ts` already read `year`/`month` from `url.searchParams` (done in feature 004) — no change needed if correct

**Checkpoint**: US2 fully testable — selecting any period in the sidebar updates all three data screens (General, Gastos, Ingresos) to the selected period without extra interaction.

---

## Phase 5: User Story 3 - Eliminar selectores embebidos en Gastos e Ingresos (Priority: P2)

**Goal**: Expenses and Incomes pages no longer show their own embedded YearMonthSelector.

**Independent Test**: Navigate to `/expenses` and `/incomes` — neither page shows a YearMonthSelector aside panel. The global sidebar selector is the only period control visible.

- [x] T010 [US3] Remove from `kakebo-front/src/routes/expenses/+page.svelte`: the `import { YearMonthSelector } from '$lib/components/filters'` line; the `handlePeriodSelect` function; the `<aside>` containing `<YearMonthSelector>`; the `$: selectedPeriod.set(...)` reactive statement; replace the `<div class="flex gap-6">` layout wrapper with a single full-width container for the table/empty-state
- [x] T011 [P] [US3] Remove from `kakebo-front/src/routes/incomes/+page.svelte`: the same set of items — `YearMonthSelector` import, `handlePeriodSelect`, the `<aside>`, the `$: selectedPeriod.set(...)` reactive statement; replace the flex layout with a full-width container
- [x] T012 [US3] Remove the `import { selectedPeriod } from '$lib/stores'` line from both `expenses/+page.svelte` and `incomes/+page.svelte` IF `selectedPeriod` is no longer used on those pages after T010/T011 (the store sync is now managed by the layout)

**Checkpoint**: US3 fully testable — Gastos and Incomes pages show only their table/empty-state with no embedded selector.

---

## Phase 6: Polish (Original)

**Purpose**: Type safety, sync cleanup, and initial verification

- [x] T013 Move the `selectedPeriod` store sync into `kakebo-front/src/routes/+layout.svelte`: add `$effect(() => { selectedPeriod.set({ year: ..., month: ... }) })` so the store reflects the global URL state
- [x] T014 [P] Run `npm run check` in `kakebo-front/` and fix any TypeScript errors introduced by changes to layout, page.server.ts, or page.svelte files
- [x] T015 [P] Manually verify the full navigation flow: open `/`, check period shows current month → select previous month in sidebar → General updates → navigate to Gastos → same month shown → navigate to Ingresos → same month shown

---

## Phase 7: User Story 4 - Etiqueta de período en Resumen mensual (Clarificación 2026-06-21)

**Goal**: The "Resumen mensual" section heading inside the General page AND the `/resumen` page heading both display the currently selected month and year.

**Context**: FR-009 and FR-010 from the clarification. The `/resumen` page currently has static hardcoded data; only the heading needs to be dynamic. No data filtering is required for this route.

**Independent Test**: Select March 2024 in the sidebar selector → navigate to General — the "Resumen mensual" section heading shows "Resumen mensual · Marzo 2024" → navigate to `/resumen` — the page heading also shows "Resumen mensual · Marzo 2024".

### Implementation for User Story 4

- [x] T016 [US4] Update `kakebo-front/src/routes/+page.svelte` (General): change the "Resumen mensual" article heading from `<h2 class="text-lg font-semibold">Resumen mensual</h2>` to `<h2 class="text-lg font-semibold">Resumen mensual · {currentMonth}</h2>` — `currentMonth` is already derived in the script block from `data.year` / `data.month`
- [x] T017 [US4] Create `kakebo-front/src/routes/resumen/+page.server.ts`: export a `load({ url })` function that reads `year` and `month` from `url.searchParams` (defaulting to `new Date().getFullYear()` and `new Date().getMonth() + 1`); return `{ year, month }`
- [x] T018 [US4] Update `kakebo-front/src/routes/resumen/+page.svelte`: add `export let data: { year: number; month: number }`; derive `currentMonth` using `new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(new Date(data.year, data.month - 1))` with capitalised first letter; update the page `<h1>` from `Resumen mensual` to `Resumen mensual · {currentMonth}`
- [x] T019 [P] Run `npm run check` in `kakebo-front/` and fix any TypeScript errors introduced by T016–T018

**Checkpoint**: US4 fully testable — "Resumen mensual · {mes} {año}" appears in both the General page section and the `/resumen` page heading when a period is selected in the sidebar.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phases 1–6**: Complete ✓
- **Phase 7 (US4)**: No blocking dependencies — T016, T017, T018 can run in parallel (different files); T019 depends on all three

### Parallel Opportunities within Phase 7

- T016, T017, T018 can run in parallel (different files)
- T019 must run after T016–T018

```bash
# Run in parallel:
Task T016: Update General +page.svelte (Resumen mensual heading)
Task T017: Create resumen/+page.server.ts
Task T018: Update resumen/+page.svelte

# Then sequentially:
Task T019: npm run check
```

---

## Implementation Strategy

### Remaining work (Phase 7 only)

1. T016 + T017 + T018 in parallel (3 file changes)
2. T019: type check
3. Manual verify: select a period → check General "Resumen mensual · {mes}" → check `/resumen` "Resumen mensual · {mes}"

---

## Notes

- T016 reuses the `currentMonth` variable already in `+page.svelte` — no new derivation needed
- T017 follows the same pattern as `expenses/+page.server.ts` and `incomes/+page.server.ts`
- T018 can read the period from URL params server-side (preferred for SSR) or from the `selectedPeriod` store client-side; server-side is preferred for consistency
- The `/resumen` page data remains static — only the heading changes to reflect the selected period
