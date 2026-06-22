# Data Model: Resumen con Datos Reales por Período

**Branch**: `006-resumen-datos-periodo` | **Date**: 2026-06-22

## ResumenPageData

Shape returned by `kakebo-front/src/routes/resumen/+page.server.ts`.

| Field | Type | Source | Notes |
|-------|------|--------|-------|
| `year` | `number` | URL `?year=` param or `now.getFullYear()` | Integer |
| `month` | `number` | URL `?month=` param or `now.getMonth() + 1` | 1–12 |
| `monthName` | `string` | `Intl.DateTimeFormat('es-ES', { month: 'long' })` | e.g. `"junio"` (lowercase) |
| `totalIncome` | `number` | `sum(incomes[].amount)` | EUR, 2 decimal precision from API |
| `totalExpenses` | `number` | `sum(expenses[].amount)` | EUR, 2 decimal precision from API |
| `savings` | `number` | `totalIncome - totalExpenses` | May be negative |
| `savingsRate` | `number` | `totalIncome === 0 ? 0 : round((savings / totalIncome) * 1000) / 10` | 0.0–∞, 1 decimal |
| `error` | `string \| undefined` | Catch block in load | Present only when fetch fails |

### Validation rules

- `savingsRate` is exactly 0 when `totalIncome === 0` — no division performed (FR-007).
- `savings` and `savingsRate` may be negative when expenses exceed income — displayed as-is (FR-006, edge case in spec).
- When both arrays are empty (no movements), all numeric totals are 0 and `error` is absent (FR-008).
- When an API call throws, `error` is populated and all numeric fields default to 0 to avoid rendering `undefined` values (FR-009).

### TypeScript interface

```ts
interface ResumenPageData {
  year: number;
  month: number;
  monthName: string;
  totalIncome: number;
  totalExpenses: number;
  savings: number;
  savingsRate: number;
  error?: string;
}
```

## Upstream types (unchanged)

These are defined in `src/lib/api.ts` and are consumed only inside `+page.server.ts` to produce the aggregated values above. They are not forwarded to `+page.svelte`.

| Type | Relevant field |
|------|---------------|
| `Expense` | `amount: number` |
| `Income` | `amount: number` |
