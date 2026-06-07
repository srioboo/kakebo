# Tasks: API-First Contract and Project Wiki

**Input**: Design documents from `/specs/001-api-first-wiki/`  
**Prerequisites**: plan.md, spec.md

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel
- **[Story]**: Which user story the task belongs to
- Include exact file paths in descriptions

---

## Phase 1: Discovery and Contract Inventory

**Purpose**: Capture the current interface surface and documentation entry
points before writing the shared contract.

- [x] T001 [P] [US1] Inventory the current API surface in `kakebo-backend/src/main/java/org/sirantar/kakebo/expenses/infrastructure/rest/ExpensesController.java`, `kakebo-backend/src/main/java/org/sirantar/kakebo/income/infrastructure/rest/IncomeController.java`, `kakebo-front/src/lib/api.ts`, `kakebo-front/src/routes/+page.server.ts`, `kakebo-front/src/routes/expenses/+page.server.ts`, and `kakebo-front/src/routes/incomes/+page.server.ts`.
- [x] T002 [P] [US1] Inventory current documentation entry points in `README.md`, `kakebo-backend/README.md`, `kakebo-backend/docs/00_INDEX.md`, and `kakebo-front/README.md` so the shared contract and wiki can replace duplicated guidance.

**Checkpoint**: The current contract and documentation gaps are understood.

---

## Phase 2: Shared Contract Source of Truth

**Purpose**: Define the single contract that backend and frontend should point
to.

- [x] T003 [US1] Create `docs/api-contract.md` as the canonical project contract using the current `Expenses` and `Incomes` response shapes, endpoint list, and ownership rules.
- [x] T004 [US1] Cross-reference the contract from any source comments or doc notes that currently describe the same API shape, keeping `kakebo-front/src/lib/api.ts` and backend controller notes aligned with `docs/api-contract.md`.

**Checkpoint**: The project has one shared contract reference.

---

## Phase 3: Project Wiki Docs

**Purpose**: Add the repository-level wiki that explains the current project
state and usage.

- [x] T005 [US2] Create `docs/README.md` as the wiki home with navigation to the contract, project state, and usage pages.
- [x] T006 [US2] Create `docs/project-state.md` describing the current project structure, active backend/frontend areas, and the separate admin project boundary.
- [x] T007 [US2] Create `docs/usage.md` with setup and usage guidance for the repository-level project wiki.

**Checkpoint**: The wiki area exists and documents the current state of the project.

---

## Phase 4: Entry Point Alignment

**Purpose**: Make the main docs and project readmes point to the shared wiki and
contract.

- [x] T008 [P] [US3] Update `README.md` so the repository root points first to `docs/README.md` and `docs/api-contract.md` as the main project documentation entry points.
- [x] T009 [P] [US3] Update `kakebo-backend/README.md` and `kakebo-backend/docs/00_INDEX.md` to link to the repository wiki and avoid repeating top-level project summaries.
- [x] T010 [P] [US3] Update `kakebo-front/README.md` to point contributors to the shared wiki and contract before the frontend-specific usage notes.

**Checkpoint**: The main documentation entry points all lead to the same story.

---

## Phase 5: Consistency Review

**Purpose**: Verify that the docs now present one coherent view of the
project.

- [x] T011 [US3] Review all touched documentation for duplicate, conflicting, or outdated guidance and tighten wording in `README.md`, `kakebo-backend/README.md`, `kakebo-backend/docs/00_INDEX.md`, `kakebo-front/README.md`, and the new `docs/*.md` pages.

**Checkpoint**: The repository presents one consistent contract and wiki.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Discovery (Phase 1)**: No dependencies - can start immediately.
- **Shared Contract (Phase 2)**: Depends on Discovery.
- **Project Wiki Docs (Phase 3)**: Depends on Shared Contract.
- **Entry Point Alignment (Phase 4)**: Depends on the wiki and contract pages.
- **Consistency Review (Phase 5)**: Depends on all prior phases.

### Task Dependencies

- **T003** depends on **T001** and **T002**.
- **T004** depends on **T003**.
- **T005**, **T006**, and **T007** depend on **T003**.
- **T008**, **T009**, and **T010** depend on **T005**, **T006**, and **T007**.
- **T011** depends on **T008**, **T009**, and **T010**.

### Parallel Opportunities

- T001 and T002 can run in parallel.
- T006 and T007 can run in parallel once the wiki home exists.
- T008, T009, and T010 can run in parallel after the wiki pages are ready.

---

## Implementation Strategy

### MVP First

1. Complete Discovery.
2. Publish the shared contract in `docs/api-contract.md`.
3. Add the wiki home and supporting pages.
4. Update the main entry points to point at the new documentation.
5. Perform the consistency review.

### Incremental Delivery

1. Start with the contract page so every other doc has a single reference.
2. Add the wiki pages around that contract.
3. Update root, backend, and frontend entry points.
4. Finish with a repo-wide wording and link review.

---

## Notes

- The separate admin project stays out of scope unless explicitly added later.
- Keep the contract and wiki focused on the current project state, not future
  proposals.
- Prefer cross-links over duplicated explanations.
