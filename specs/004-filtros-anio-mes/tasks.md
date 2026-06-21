# Tasks: Filtros por Año y Mes en Movimientos

**Input**: Design documents from `/specs/004-filtros-anio-mes/`
**Prerequisites**: spec.md (user stories), existing codebase analysis

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Exact file paths included in all descriptions

## Path Conventions

```text
kakebo-backend/src/main/java/org/sirantar/kakebo/
├── expenses/domain/repository/ExpensesRepository.java
├── expenses/application/service/ExpensesService.java
├── expenses/infrastructure/rest/ExpensesController.java
├── income/domain/repository/IncomeRepository.java
├── income/application/service/IncomeService.java
└── income/infrastructure/rest/IncomeController.java

kakebo-front/src/
├── lib/api.ts
├── lib/stores.ts
├── lib/components/filters/YearMonthSelector.svelte  ← new
├── routes/expenses/+page.server.ts
├── routes/expenses/+page.svelte
├── routes/incomes/+page.server.ts
└── routes/incomes/+page.svelte
```

---

## Phase 1: Setup (Entorno de Desarrollo)

**Purpose**: Verify both subprojects start cleanly before any changes

- [x] T001 Verify backend starts with dev profile: `./mvnw spring-boot:run -Dspring.profiles.active=dev` and confirm `GET /expenses` and `GET /incomes` return data at `http://localhost:9090`
- [x] T002 [P] Verify frontend starts: `npm run dev` in `kakebo-front/` and confirm expenses and incomes pages load at `http://localhost:5173`

---

## Phase 2: Foundational (Infraestructura de Filtrado en Repositorios)

**Purpose**: JPA query methods needed by both US1 and US2 backend tasks — BLOCKS all user story backend work

**⚠️ CRITICAL**: No user story backend work can begin until this phase is complete

- [x] T003 Add `findByYearAndMonth` JPQL query to `kakebo-backend/src/main/java/org/sirantar/kakebo/expenses/domain/repository/ExpensesRepository.java`: `@Query("SELECT e FROM Expenses e WHERE YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month")` returning `List<Expenses>`
- [x] T004 [P] Add `findByYearAndMonth` JPQL query to `kakebo-backend/src/main/java/org/sirantar/kakebo/income/domain/repository/IncomeRepository.java` on `incomeDate` field, returning `List<Incomes>`

**Checkpoint**: Repositories can filter by year/month — service and controller updates can now begin in parallel

---

## Phase 3: User Story 1 - Ver movimientos del mes actual por defecto (Priority: P1) 🎯 MVP

**Goal**: Backend defaults to current month/year when no filters are given; frontend loads current month on entry.

**Independent Test**: Open `/expenses` and `/incomes` with no URL params — both show only rows where `expenseDate`/`incomeDate` falls within the current month and year.

### Implementation for User Story 1

- [x] T005 Update `getExpenses(int year, int month)` in `kakebo-backend/src/main/java/org/sirantar/kakebo/expenses/application/service/ExpensesService.java` to call `expensesRepository.findByYearAndMonth(year, month)` instead of `findAll()`
- [x] T006 Update `getExpenses()` in `kakebo-backend/src/main/java/org/sirantar/kakebo/expenses/infrastructure/rest/ExpensesController.java` to accept `@RequestParam(required = false) Integer year` and `@RequestParam(required = false) Integer month`, defaulting both to `LocalDate.now()` values when null; return `ResponseEntity.badRequest()` if month outside 1–12 or year < 2000; add `@Parameter` Swagger annotations for both params
- [x] T007 [P] Update `getIncomes(int year, int month)` in `kakebo-backend/src/main/java/org/sirantar/kakebo/income/application/service/IncomeService.java` to call `incomeRepository.findByYearAndMonth(year, month)` instead of `findAll()`
- [x] T008 [P] Update `getIncomes()` in `kakebo-backend/src/main/java/org/sirantar/kakebo/income/infrastructure/rest/IncomeController.java`: add `@CrossOrigin(origins = "https://localhost:5173")` (currently missing — blocks frontend), accept optional `year`/`month` params with same defaulting and validation logic as T006
- [x] T009 Update `getExpenses(year?: number, month?: number)` signature in `kakebo-front/src/lib/api.ts`: build query string `?year=Y&month=M` and append to `/expenses` fetch URL when params are provided
- [x] T010 [P] Update `getIncomes(year?: number, month?: number)` signature in `kakebo-front/src/lib/api.ts` to append `?year=Y&month=M` to `/incomes` fetch URL
- [x] T011 Update `load({ url })` in `kakebo-front/src/routes/expenses/+page.server.ts` to read `year` and `month` from `url.searchParams`, default to current month/year when absent, and pass them to `getExpenses(year, month)`
- [x] T012 [P] Update `load({ url })` in `kakebo-front/src/routes/incomes/+page.server.ts` to read `year` and `month` from `url.searchParams`, default to current month/year, and pass to `getIncomes(year, month)`

**Checkpoint**: Opening `/expenses` or `/incomes` with no URL params shows only current-month data. US1 fully functional.

---

## Phase 4: User Story 2 - Consultar meses anteriores desde submenús por año/mes (Priority: P1)

**Goal**: A hierarchical year → month selector lets the user navigate to any historical period without leaving the page.

**Independent Test**: Select any year/month from the selector — the URL updates to `?year=Y&month=M` and the list refreshes to show only matching rows (or an empty state with a message).

### Implementation for User Story 2

- [x] T013 Create `kakebo-front/src/lib/components/filters/YearMonthSelector.svelte`: Svelte 5 component that accepts `currentYear: number` and `currentMonth: number` props; renders a collapsible list of years (from 2023 to `new Date().getFullYear()`) each containing a flat list of months 1–12 (labelled with locale month names via `Intl.DateTimeFormat`); emits `select(year, month)` event when a month is clicked; highlights the active year/month
- [x] T014 Integrate `YearMonthSelector` into `kakebo-front/src/routes/expenses/+page.svelte`: import and render the component, handle the `select` event by calling `goto('?year=Y&month=M')` from `$app/navigation` to trigger server-side reload
- [x] T015 [P] Integrate `YearMonthSelector` into `kakebo-front/src/routes/incomes/+page.svelte` with the same `goto` pattern
- [x] T016 Add empty-state message to `kakebo-front/src/routes/expenses/+page.svelte` when `expenses` array is empty: display "No hay gastos para el período seleccionado" with the selected month/year
- [x] T017 [P] Add empty-state message to `kakebo-front/src/routes/incomes/+page.svelte` when `incomes` array is empty: display "No hay ingresos para el período seleccionado" with the selected month/year

**Checkpoint**: Clicking any year/month in the selector refreshes the list to that period. Empty periods show a message instead of a blank table. US2 fully functional.

---

## Phase 5: User Story 3 - Consistencia de filtros en ingresos y gastos (Priority: P2)

**Goal**: Both modules use identical filter logic, visual layout, and default/reset behavior.

**Independent Test**: Apply the same year/month in expenses, navigate to incomes and apply the same — both show consistent results. Reset to current month in one and confirm the other also resets correctly.

### Implementation for User Story 3

- [x] T018 Add `selectedPeriod` writable store `{ year: number, month: number }` to `kakebo-front/src/lib/stores.ts`, initialized with current date; update `YearMonthSelector` to read initial value from this store
- [x] T019 Update `kakebo-front/src/routes/expenses/+page.svelte` to sync `selectedPeriod` store from the current URL params on page load (using `page` store from `$app/stores`), so the selector reflects the active period from the URL
- [x] T020 [P] Apply the same `selectedPeriod` sync pattern to `kakebo-front/src/routes/incomes/+page.svelte`
- [x] T021 Ensure `YearMonthSelector.svelte` visual style (padding, colors, active state highlight) is identical between the expenses and incomes integrations — extract any inline styles into a shared CSS class in `kakebo-front/src/app.css` if needed

**Checkpoint**: Expenses and incomes pages are visually and behaviourally identical in their filter UX. US3 fully functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Type safety, i18n, and test confirmation across the full feature

- [x] T022 [P] Add i18n keys to `kakebo-front/messages/es.json` and `kakebo-front/messages/en.json` for filter UI labels: `filter_year`, `filter_month`, `filter_no_expenses`, `filter_no_incomes`, `filter_reset`; update `YearMonthSelector.svelte` and the empty-state elements to use Paraglide message keys
- [x] T023 [P] Run `npm run check` in `kakebo-front/` and fix any TypeScript type errors introduced by the `year`/`month` param additions to `getExpenses`/`getIncomes`
- [x] T024 Add REST integration tests in `kakebo-backend/src/test/java/org/sirantar/kakebo/expenses/` for: (a) `GET /expenses` returns only current-month rows, (b) `GET /expenses?year=2026&month=1` returns January 2026 rows, (c) `GET /expenses?month=13` returns HTTP 400; follow `@SpringBootTest(webEnvironment = RANDOM_PORT)` + plain `RestTemplate` + JsonPath pattern from CLAUDE.md
- [x] T025 [P] Add equivalent REST integration tests in `kakebo-backend/src/test/java/org/sirantar/kakebo/income/` for `GET /incomes` with the same three scenarios
- [x] T026 Run `make test` in `kakebo-backend/` and confirm all existing and new tests pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all backend user story work
- **US1 Backend (T005–T008)**: Depends on Phase 2 (repositories ready)
- **US1 Frontend (T009–T012)**: Depends on US1 Backend being callable; T009/T010 can start once API signatures are known
- **US2 Frontend (T013–T017)**: Depends on US1 Frontend — URL param routing must exist before adding selector
- **US3 (T018–T021)**: Depends on US2 — selector must exist before adding shared store sync
- **Polish (Phase 6)**: Depends on US3 completion

### User Story Dependencies

- **US1 (P1)**: Core backend + frontend wiring — start immediately after Phase 2
- **US2 (P1)**: Frontend-only; depends on US1 URL param routing being in place
- **US3 (P2)**: Depends on US2 selector component existing

### Within Each Phase

- Tasks marked [P] touch different files and can be executed in parallel
- Backend (T005–T008) and Frontend (T009–T012) within US1 can overlap once the API contract is understood
- T016/T017 (empty states) are independent of T013–T015 (selector) and can run in parallel within US2

---

## Parallel Example: User Story 1

```bash
# Backend (after Phase 2 completes):
Task T005: Update ExpensesService
Task T007: Update IncomeService         ← parallel with T005

Task T006: Update ExpensesController    ← after T005
Task T008: Update IncomeController      ← after T007, parallel with T006

# Frontend (can start once API contract is clear):
Task T009: Update api.ts getExpenses
Task T010: Update api.ts getIncomes     ← parallel with T009

Task T011: Update expenses/+page.server.ts   ← after T009
Task T012: Update incomes/+page.server.ts    ← after T010, parallel with T011
```

---

## Implementation Strategy

### MVP First (User Stories 1 + 2 Only)

1. Complete Phase 1: Verify environment
2. Complete Phase 2: Add repository query methods
3. Complete Phase 3 (US1): Backend defaults + frontend URL params
4. **STOP and VALIDATE**: Opening expenses/incomes without params shows current month ✓
5. Complete Phase 4 (US2): Year/month selector UI
6. **STOP and VALIDATE**: Selector navigates to historical periods ✓
7. Deploy/demo MVP

### Incremental Delivery

1. Phase 1+2 → dev environment ready
2. Phase 3 → current month by default (US1 done, deploy-ready)
3. Phase 4 → historical browsing (US2 done, deploy-ready)
4. Phase 5 → UI consistency (US3 done, polish)
5. Phase 6 → type safety + i18n + tests

---

## Notes

- `@CrossOrigin` is missing from `IncomeController` (T008) — this is a pre-existing bug that blocks all frontend→incomes calls; fixing it is mandatory for US1
- The backend date field is `LocalDateTime`; `YEAR()` and `MONTH()` JPQL functions work with both H2 (dev) and PostgreSQL (prod)
- Month validation rejects values outside 1–12; year validation rejects values < 2000 (FR-008)
- The selector generates year range client-side (2023 → current year); no new backend endpoint for available years is needed for MVP
- Commit after each phase checkpoint using Conventional Commits format (enforced by Husky pre-commit hook)
