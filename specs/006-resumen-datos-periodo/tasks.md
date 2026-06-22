# Tasks: Resumen con Datos Reales por Período

**Input**: Design documents from `/specs/006-resumen-datos-periodo/`
**Prerequisites**: spec.md (user stories), plan.md (tech context)

**Context**: Features 004 and 005 are already complete. The backend already supports `GET /expenses?year=Y&month=M` and `GET /incomes?year=Y&month=M`. The global period selector in the layout already navigates `/resumen` with URL params when the user selects a period. The `/resumen` page already has a `+page.server.ts` that reads year/month and a heading that shows the selected month. This feature replaces the static hardcoded metric values with real computed data.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Exact file paths included in all descriptions

## Path Conventions

```text
kakebo-front/src/
├── routes/resumen/+page.server.ts   ← UPDATE: fetch real expenses + incomes
└── routes/resumen/+page.svelte      ← UPDATE: compute and display real totals

# Unchanged (already correct):
kakebo-front/src/lib/api.ts          ← getExpenses(year?, month?): Promise<Expense[]>
                                        getIncomes(year?, month?): Promise<Income[]>
                                        formatCurrency(amount): string
kakebo-front/src/routes/+layout.svelte ← already navigates /resumen with ?year=Y&month=M
```

---

## Phase 1: Setup (Verificación de Prerequisites)

**Purpose**: Confirm features 004 and 005 foundations are in place — no code changes, start immediately

- [x] T001 Verify `kakebo-front/src/lib/api.ts` exports `getExpenses(year?, month?)`, `getIncomes(year?, month?)`, and `formatCurrency` (all must exist before updating +page.server.ts)
- [x] T002 [P] Verify `kakebo-front/src/routes/resumen/+page.server.ts` exists and already reads `year`/`month` from `url.searchParams` (created in feature 005 clarification)
- [x] T003 [P] Verify `kakebo-front/src/routes/+layout.svelte` already calls `goto(page.url.pathname + '?year=Y&month=M')` — confirming that selecting a period while on `/resumen` already navigates with URL params (no change needed in layout)

---

## Phase 2: User Story 1 - Resumen responde al selector de período (Priority: P1) 🎯 MVP

**Goal**: The Resumen page already responds to period selection via URL params from feature 005. This phase verifies the behavior end-to-end and confirms no additional wiring is needed.

**Independent Test**: Navigate to `/resumen`, select a different month in the sidebar — the URL changes to `/resumen?year=Y&month=M` and the heading updates to "Resumen mensual · {mes} {año}". No data changes visible yet (static values still shown); that is the scope of US2.

### Implementation for User Story 1

- [x] T004 [US1] Verify end-to-end: navigate to `/resumen` → select a previous month in the sidebar → confirm the URL updates to `/resumen?year=Y&month=M` and the `<h1>` heading reflects the selected period — no code changes required if behavior is already correct; document any gap found

**Checkpoint**: US1 fully testable independently — the Resumen page URL and heading respond to period selection from the sidebar.

---

## Phase 3: User Story 2 - Datos reales de ingresos, gastos y ahorros (Priority: P1)

**Goal**: Replace the four hardcoded static metric values in `/resumen` (Ingresos, Gastos, Ahorro, Tasa de ahorro) with real data computed from the backend for the selected period.

**Independent Test**: With 2.000 EUR of incomes and 1.500 EUR of expenses for the selected period in the database, the Resumen page shows: Ingresos 2.000,00 EUR, Gastos 1.500,00 EUR, Ahorro 500,00 EUR, Tasa de ahorro 25,0%. For a period with no data, all four values show 0.

### Implementation for User Story 2

- [x] T005 [US2] Update `kakebo-front/src/routes/resumen/+page.server.ts`: add `import { getExpenses, getIncomes } from '$lib/api'`; extend the existing load function to call `getExpenses(year, month)` and `getIncomes(year, month)` inside a try/catch; return `{ expenses, incomes, year, month }` on success or `{ expenses: [], incomes: [], year, month, error: string }` on failure
- [x] T006 [US2] Update `kakebo-front/src/routes/resumen/+page.svelte`: add `import { formatCurrency, type Expense, type Income } from '$lib/api'` in the `<script>` block; update `export let data` to type `{ expenses?: Expense[] | { data?: Expense[] }; incomes?: Income[] | { data?: Income[] }; year: number; month: number; error?: string }`; add a `getList<T>()` helper (same pattern as `+page.svelte` General) to normalize the response shape; compute `totalIncome`, `totalExpenses`, `savings`, `savingsRate` (guarded: `totalIncome === 0 ? 0 : Math.round((savings / totalIncome) * 1000) / 10`); replace the four hardcoded metric card values with `{formatCurrency(totalIncome)}`, `{formatCurrency(totalExpenses)}`, `{formatCurrency(savings)}`, `{savingsRate.toFixed(1)}%`; add an error banner (`data.error`) above the metrics section using the same pattern as expenses/incomes pages

**Checkpoint**: US2 fully testable — the Resumen page shows real totals from the database for the selected period. A period with no data shows all zeros without errors.

---

## Phase 4: Polish & Validación

**Purpose**: Type safety and manual end-to-end verification

- [x] T007 [P] Run `npm run check` in `kakebo-front/` and fix any TypeScript errors introduced by T005–T006
- [x] T008 [P] Manual end-to-end verification: start the backend (`./mvnw spring-boot:run -Dspring.profiles.active=dev`), open `/resumen` in the browser → verify all four metrics show 0 for an empty month → add income and expense records for the current month in the Gastos/Ingresos pages → return to Resumen and verify totals match → select a different period in the sidebar and verify Resumen updates to that period's data

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately; T001, T002, T003 can run in parallel
- **Phase 2 (US1)**: Depends on Phase 1 — T004 is a verification step only, no code change expected
- **Phase 3 (US2)**: Depends on Phase 1; T005 and T006 affect different files and can run in parallel; T006 has a soft dependency on T005 (data shape defined in server must match type in page)
- **Phase 4 (Polish)**: T007 depends on T005+T006; T008 depends on T007

### Parallel Opportunities

```bash
# Phase 1 — all in parallel:
T001: Verify api.ts exports
T002: Verify resumen/+page.server.ts exists
T003: Verify layout already handles /resumen navigation

# Phase 3 — T005 and T006 can run in parallel (different files):
T005: Update +page.server.ts (data fetching)
T006: Update +page.svelte (display logic)

# Phase 4 — T007 and T008 can run in parallel:
T007: npm run check
T008: Manual browser verification
```

---

## Implementation Strategy

### MVP First (US1 already done, focus on US2)

1. Complete Phase 1: Verify prerequisites
2. Complete Phase 2: Confirm US1 (navigation) already works
3. Complete Phase 3: Add real data to Resumen page (T005 + T006 in parallel)
4. **STOP and VALIDATE**: `npm run check` passes → manually verify Resumen shows real data
5. Done

### Key Implementation Notes

- **T005 data return shape**: The backend may return a plain array or a `{ data: [...] }` wrapper — the `getList()` helper normalizes this. Copy the pattern from `kakebo-front/src/routes/+page.svelte` (General page).
- **T006 savingsRate formula**: `totalIncome === 0 ? 0 : Math.round((savings / totalIncome) * 1000) / 10` — rounds to 1 decimal place (e.g., 24.6).
- **T006 negative savings**: If `expenses > incomes`, `savings` is negative and `savingsRate` is negative — display as-is without special handling.
- **T006 error state**: Wrap the data fetch in try/catch in T005; if `data.error` is present in T006, show the error banner and still render the metric cards with zero values.

---

## Notes

- US1 (period navigation) is already implemented by feature 005's layout changes — T004 is a verification step, not an implementation step
- The `+page.server.ts` for `/resumen` already exists (created in feature 005 clarification) and returns `{ year, month }` — T005 extends it to also return `{ expenses, incomes }`
- The `+page.svelte` already has the `<script>` block with `data` prop and `currentMonth` derived — T006 extends it with the real data computation
- No new API functions needed — `getExpenses` and `getIncomes` already accept optional year/month params
