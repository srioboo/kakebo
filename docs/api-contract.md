# API Contract

This file is the canonical API contract for the repository. Backend is the source of truth for implementation; frontend and docs must reference this page when describing endpoints and payloads.

## Overview

Public endpoints (root path `http://localhost:9090`):

- GET /expenses → list of Expense
- GET /expenses/{id} → Expense
- POST /expenses → Expense (creates)
- PUT /expenses/{id} → Expense (updates, partial fields allowed)
- DELETE /expenses/{id} → 204 No Content

- GET /incomes → list of Income
- GET /incomes/{id} → Income
- POST /incomes → Income (creates)
- PUT /incomes/{id} → Income (updates, partial fields allowed)
- DELETE /incomes/{id} → 204 No Content

## Data Shapes

Expense
- id: integer (nullable for client-created payloads)
- amount: decimal (positive)
- expenseName: string
- expenseDate: string (ISO 8601, e.g. 2026-06-04T12:00:00)

Income
- id: integer (nullable for client-created payloads)
- amount: decimal (positive)
- incomeName: string
- incomeDate: string (ISO 8601)

## Contract Rules & Ownership

- Ownership: Backend (`kakebo-backend`) owns canonical shapes and routes. Any change to shapes or semantics MUST be documented here and coordinated with frontend.
- Partial updates: PUT endpoints accept partial payloads (only non-null fields are applied).
- Empty fallback: Some GET-by-id endpoints may return an empty/default object rather than 404; callers should handle both cases.
- Documentation: Backend controllers include Swagger annotations; this contract is the human-readable canonical reference for engineering and reviewers.

## Versioning & Change Process

- Small clarifications: PATCH version (docs only).
- New/removed fields or breaking changes: MAJOR version and cross-team coordination (update this file and notify frontend).

## Notes

- Frontend API layer (`kakebo-front/src/lib/api.ts`) is expected to validate client payloads and convert local format to the contract format.
- Do not edit generated i18n or generated artifacts to document API; update this file instead.
