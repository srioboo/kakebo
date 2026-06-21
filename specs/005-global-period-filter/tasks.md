# Tasks: Selector de Período Global en Navegación

**Input**: Design documents from `/specs/005-global-period-filter/`
**Prerequisites**: spec.md (user stories), existing codebase analysis

**Context from feature 004**: Year/month filtering is already implemented in the backend (`GET /expenses?year=Y&month=M`, `GET /incomes?year=Y&month=M`). The `YearMonthSelector.svelte` component and `selectedPeriod` store already exist. This feature moves the selector from inside each page into the shared layout.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Exact file paths included in all descriptions

## Path Conventions

```text
kakebo-front/src/
├── routes/+layout.svelte              ← add global selector here
├── routes/+page.server.ts             ← update to read year/month from URL
├── routes/+page.svelte                ← update month name display
├── routes/expenses/+page.svelte       ← remove embedded selector (US3)
├── routes/incomes/+page.svelte        ← remove embedded selector (US3)
├── lib/stores.ts                      ← selectedPeriod store (already exists)
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

**⚠️ CRITICAL**: US2 and US3 cannot be validated until the layout selector is functional

- [x] T003 Update `kakebo-front/src/routes/+layout.svelte`: import `YearMonthSelector` from `$lib/components/filters`; import `goto` from `$app/navigation`; derive `activeYear` and `activeMonth` from `page.url.searchParams` (defaulting to current date values when absent); add a `handlePeriodSelect` function that calls `goto(page.url.pathname + '?year=${year}&month=${month}')`
- [x] T004 Update `kakebo-front/src/routes/+layout.svelte`: add `YearMonthSelector` component inside the AppRail default slot (below the last `AppRailAnchor` nav item, before the trail slot); pass `currentYear={activeYear}` and `currentMonth={activeMonth}` props; wire `on:select={handlePeriodSelect}`; add a visual section label "Período" above the selector

**Checkpoint**: Reload any app page — the sidebar shows the YearMonthSelector with the current month highlighted. Clicking a different month updates the URL params (`?year=Y&month=M`) and the selector highlight updates.

---

## Phase 3: User Story 1 - Selector global visible en todo momento (Priority: P1) 🎯 MVP

**Goal**: The YearMonthSelector is always visible in the AppRail sidebar from any screen in the app.

**Independent Test**: Navigate to `/`, `/diario`, `/expenses`, `/incomes`, `/resumen` — the sidebar shows the period selector at all times with the active period highlighted. Changing the month on any page updates the URL.

### Implementation for User Story 1

- [x] T005 [US1] Verify `kakebo-front/src/routes/+layout.svelte` correctly derives active year/month: when URL has `?year=2020&month=1`, the selector highlights January 2020; when URL has no params, it highlights the current month/year
- [x] T006 [US1] Verify the `YearMonthSelector` label in the AppRail does not overlap or hide any navigation anchors (General, Diario, Gastos, Ingresos, Resumen, Ayuda) on typical viewport sizes; adjust padding/spacing if needed

**Checkpoint**: US1 fully testable independently — the global selector is always present and reflects the URL state.

---

## Phase 4: User Story 2 - Período aplicado a todas las pantallas con datos (Priority: P1)

**Goal**: Selecting a period in the global selector causes the General, Expenses, and Incomes pages to show only data from that period.

**Independent Test**: Select January 2020 in the sidebar selector from the General page — the General page shows incomes and expenses from January 2020 only. Navigate to Gastos — also shows January 2020 data. Navigate to Ingresos — same.

### Implementation for User Story 2

- [x] T007 [US2] Update `kakebo-front/src/routes/+page.server.ts` (General): change `load()` to `load({ url })`, read `year` and `month` from `url.searchParams` defaulting to current date values, then call `getExpenses(year, month)` and `getIncomes(year, month)`; return `{ expenses, incomes, year, month }`
- [x] T008 [US2] Update `kakebo-front/src/routes/+page.svelte` (General): replace hardcoded `new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(new Date())` with a dynamic month/year label built from `data.year` and `data.month`; update the "Portada mensual" heading to show the selected period (e.g., "Kakebo · Junio 2026")
- [x] T009 [US2] Verify `kakebo-front/src/routes/expenses/+page.server.ts` and `incomes/+page.server.ts` already read `year`/`month` from `url.searchParams` (done in feature 004) — no change needed if correct

**Checkpoint**: US2 fully testable — selecting any period in the sidebar updates all three data screens (General, Gastos, Ingresos) to the selected period without extra interaction.

---

## Phase 5: User Story 3 - Eliminar selectores embebidos en Gastos e Ingresos (Priority: P2)

**Goal**: Expenses and Incomes pages no longer show their own embedded YearMonthSelector — only the global one in the sidebar is visible.

**Independent Test**: Navigate to `/expenses` and `/incomes` — neither page shows a YearMonthSelector aside panel. The global sidebar selector is the only period control visible.

### Implementation for User Story 3

- [x] T010 [US3] Remove from `kakebo-front/src/routes/expenses/+page.svelte`: the `import { YearMonthSelector } from '$lib/components/filters'` line; the `handlePeriodSelect` function; the `<aside>` containing `<YearMonthSelector>`; the `$: selectedPeriod.set(...)` reactive statement; replace the `<div class="flex gap-6">` layout wrapper with a single full-width container for the table/empty-state
- [x] T011 [P] [US3] Remove from `kakebo-front/src/routes/incomes/+page.svelte`: the same set of items — `YearMonthSelector` import, `handlePeriodSelect`, the `<aside>`, the `$: selectedPeriod.set(...)` reactive statement; replace the flex layout with a full-width container
- [x] T012 [US3] Remove the `import { selectedPeriod } from '$lib/stores'` line from both `expenses/+page.svelte` and `incomes/+page.svelte` IF `selectedPeriod` is no longer used on those pages after T010/T011 (the store sync is now managed by the layout)

**Checkpoint**: US3 fully testable — Gastos and Incomes pages show only their table/empty-state with no embedded selector. The global sidebar remains the only period control.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Type safety, sync cleanup, and visual verification

- [x] T013 Move the `selectedPeriod` store sync into `kakebo-front/src/routes/+layout.svelte`: add `$: selectedPeriod.set({ year: activeYear, month: activeMonth })` so the store reflects the global URL state (useful for any future page that needs the store value)
- [x] T014 [P] Run `npm run check` in `kakebo-front/` and fix any TypeScript errors introduced by changes to layout, page.server.ts, or page.svelte files
- [x] T015 [P] Manually verify the full navigation flow: open `/`, check period shows current month → select previous month in sidebar → General updates → navigate to Gastos → same month shown → navigate to Ingresos → same month shown → navigate to General → still same month

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Verify feature 004 artifacts exist — no code changes, start immediately
- **Foundational (Phase 2)**: Add selector to layout — BLOCKS US1 validation and US2/US3 testing
- **US1 (Phase 3)**: Depends on Phase 2; only layout verification and spacing adjustments
- **US2 (Phase 4)**: Depends on Phase 2 (global selector must be present); T007–T009 can run in parallel
- **US3 (Phase 5)**: Depends on Phase 2 (global selector must be present before removing embedded ones); T010/T011 can run in parallel
- **Polish (Phase 6)**: Depends on US2 + US3 completion

### User Story Dependencies

- **US1 (P1)**: Depends on Phase 2 (foundational layout changes)
- **US2 (P1)**: Depends on Phase 2; independent of US3
- **US3 (P2)**: Depends on Phase 2; should NOT be done before US2 is working (otherwise period filtering breaks)

### Parallel Opportunities within Phases

- T003 + T004 must be sequential (T004 uses what T003 adds to the script block)
- T007 + T008 can run in parallel (different files)
- T010 + T011 can run in parallel (different files)
- T014 + T015 can run in parallel (check vs manual test)

---

## Parallel Example: Phase 4 (US2)

```bash
# After Phase 2 (layout selector working):

# Run in parallel:
Task T007: Update /routes/+page.server.ts (General load function)
Task T008: Update /routes/+page.svelte (General month display)

# T009 is just a verification — can run at same time
Task T009: Verify expenses/incomes +page.server.ts already reads URL params
```

## Parallel Example: Phase 5 (US3)

```bash
# After Phase 2 and Phase 4 are confirmed working:

# Run in parallel:
Task T010: Remove embedded selector from expenses/+page.svelte
Task T011: Remove embedded selector from incomes/+page.svelte
```

---

## Implementation Strategy

### MVP First (US1 + US2 only)

1. Complete Phase 1: Verify feature 004 artifacts
2. Complete Phase 2: Add selector to AppRail layout
3. Complete Phase 3 (US1): Verify selector visibility
4. Complete Phase 4 (US2): Update General page server load
5. **STOP and VALIDATE**: All data screens filter by selected period ✓
6. Deploy/demo MVP

### Incremental Delivery

1. Phase 1+2 → global selector visible in sidebar
2. Phase 3 (US1) → selector always present, URL updates on click
3. Phase 4 (US2) → all data screens respect global period (MVP!)
4. Phase 5 (US3) → clean up embedded selectors from Gastos/Ingresos
5. Phase 6 → type safety + manual verification

---

## Notes

- `YearMonthSelector.svelte` already exists at `kakebo-front/src/lib/components/filters/YearMonthSelector.svelte` (feature 004)
- The `+layout.svelte` already imports `page` from `$app/state` — use `page.url.searchParams` directly for year/month
- `goto` from `$app/navigation` is what the page.svelte files already use; use the same pattern in the layout
- The `selectedPeriod` store in `stores.ts` already exists; after US3, the canonical sync point moves from individual pages to the layout
- DO NOT remove embedded selectors (US3) before verifying the global selector (Phase 2) is working — this avoids a period-less state for users
- Commit after each phase checkpoint using Conventional Commits format
