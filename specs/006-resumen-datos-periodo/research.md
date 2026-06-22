# Research: Resumen con Datos Reales por Período

**Branch**: `006-resumen-datos-periodo` | **Date**: 2026-06-22

## Finding 1 — Root cause of stale data on period change

**Decision**: Move all metric calculations to `+page.server.ts`.

**Rationale**: In `+page.svelte`, all derived values (`totalIncome`, `totalExpenses`, `savings`, `savingsRate`, `currentMonth`) were declared with `const` at the top of the `<script>` block. In Svelte 4, `const` expressions in the instance script are evaluated once when the component mounts. Even though SvelteKit re-runs the server `load` function on every navigation (URL param change), the Svelte component receives new `data` props but the `const` derivations are frozen from the original mount — they never update. Moving computation to the server means the `data` object itself already contains the correct numbers on every load; the template only interpolates `{data.totalIncome}` etc., which Svelte always renders reactively.

**Alternatives considered**:
- `$:` reactive declarations in `+page.svelte` — valid fix in Svelte 4 but keeps business logic in the view layer; rejected in favour of the server-side approach (FR-011) which also makes the component testable in isolation with a simple data mock.
- `$derived` runes in Svelte 5 — would also work but requires migrating the component to the runes API; out of scope.

---

## Finding 2 — Skeleton loading state during navigation

**Decision**: Use `navigating` from `$app/state` to swap metric cards for skeleton placeholders while a SvelteKit navigation is in progress.

**Rationale**: SvelteKit's `navigating` reactive value (in the `$app/state` module used elsewhere in this project) is non-null for the duration of any ongoing navigation. When the user clicks a month in `YearMonthSelector`, `goto()` in the layout triggers a navigation; `navigating` becomes truthy immediately, before the server load has returned new data. Rendering skeletons at that point gives instant visual feedback without blocking on the server round-trip.

**Alternatives considered**:
- `LoadingSpinner` (used by expenses/incomes) — suitable for CRUD operations where a single card's content is replacing itself; not the right pattern for a full card-set swap.
- No loading indicator — rejected per NFR-004.
- Custom loading store — unnecessary complexity; `navigating` already provides the signal.

---

## Finding 3 — No new API or backend changes required

**Decision**: Reuse `getExpenses(year, month)` and `getIncomes(year, month)` from `src/lib/api.ts`.

**Rationale**: Both functions already accept `year` and `month` parameters and return typed arrays. The server load function already calls both. The only change is that aggregation happens in the server function instead of the component script.

**Alternatives considered**:
- Dedicated backend summary endpoint — rejected (explicitly out of scope in spec, Fuera de Alcance section).

---

## Finding 4 — Month name localisation

**Decision**: Compute `monthName` in `+page.server.ts` using `Intl.DateTimeFormat('es-ES', { month: 'long' })`.

**Rationale**: The same `Intl` pattern is already used in `YearMonthSelector.svelte`. Moving it to the server keeps the component stateless and avoids duplicating the localisation logic.

---

## Finding 5 — No contracts directory needed

**Decision**: Skip `/contracts/` artifact for this feature.

**Rationale**: The feature introduces no new public interface. The existing backend REST contract (`GET /expenses?year=Y&month=M`, `GET /incomes?year=Y&month=M`) is unchanged. The only external interface change is the shape of the `ResumenPageData` object, which is an internal SvelteKit page data type and is documented in `data-model.md`.
