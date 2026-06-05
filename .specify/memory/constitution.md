<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles: placeholder principle 1 -> Repository Boundaries; placeholder principle 2 -> Hexagonal Backend Ownership; placeholder principle 3 -> Contract-Aligned Frontend; placeholder principle 4 -> Verify Before Merge; placeholder principle 5 -> Generated Artifacts and Localization Are Read-Only
Added sections: Engineering Constraints; Development & Quality Gates
Removed sections: none
Templates requiring updates: .specify/templates/plan-template.md ✅ aligned; .specify/templates/spec-template.md ✅ aligned; .specify/templates/tasks-template.md ✅ aligned; .specify/templates/commands/*.md ✅ none found
Follow-up TODOs: TODO(RATIFICATION_DATE): original adoption date not recorded
-->

# Kakebo Constitution

## Core Principles

### Repository Boundaries
Kakebo is a multi-subproject repository. Changes MUST stay within the owning
subproject unless the feature explicitly spans backend, frontend, or admin.
Cross-project work MUST update every affected surface together so the repo
never drifts into inconsistent partial implementations.

### Hexagonal Backend Ownership
Backend business logic MUST stay in `kakebo-backend` domain and application
layers. Controllers MUST delegate to services, repositories MUST remain
domain-facing ports/adapters, and package structure MUST keep `expenses/` and
`income/` isolated. Public REST behavior MUST preserve existing conventions,
including constructor injection, Swagger annotations, partial updates, and the
empty-object `GET` fallback, unless a deliberate breaking change is documented.

### Contract-Aligned Frontend
Frontend data access MUST go through the shared API layer and SSR loader in
`kakebo-front`; views MUST NOT bypass those adapters when a shared path exists.
When backend contracts change, the frontend API layer and route loader MUST be
updated in the same change. Generated i18n and layout conventions MUST be
respected.

### Verify Before Merge
Every code change MUST be validated with the existing commands for the touched
subproject. New tooling, build systems, or test frameworks MUST NOT be added
unless the current toolchain cannot cover the requirement. Changes MUST preserve
existing behavior unless the change explicitly intends to alter it and records
the impact.

### Generated Artifacts and Localization Are Read-Only
Generated files, especially Paraglide output, MUST NOT be edited manually.
Localized source messages and shared layout components remain the source of
truth. New user-facing text MUST flow through the repo's i18n system rather than
being hard-coded around it.

## Engineering Constraints

- Backend uses Java 21 and Spring Boot 3.x with H2 for development and
  PostgreSQL for production.
- Frontend uses SvelteKit 2, Svelte 5, Vite 6, TailwindCSS 4, and Paraglide.
- Repository style is tabs, single quotes, and no trailing commas in the
  frontend codebase.
- Environment and secret values MUST stay out of source control and use the
  documented local configuration files.
- Git workflow conventions and commit trailers from the repo guidance MUST be
  preserved.

## Development & Quality Gates

- Work in the correct subproject and use its documented commands for linting,
  testing, and builds.
- Backend changes MUST keep service/controller/repository wiring explicit and
  maintain existing API shapes unless a change intentionally expands them.
- Frontend changes MUST keep `src/lib/api` and `+page.server.*` aligned with the
  backend contract.
- Any change touching generated files, localization, or shared layout MUST be
  treated as a synchronization task, not a local one-off edit.
- Before merging, reviewers MUST be able to trace the change back to a tested
  repo convention or an explicit constitution amendment.

## Governance

This constitution supersedes conflicting guidance in local docs or ad hoc
working notes. Amendments require an updated constitution file, a semantic
version bump, and propagation to dependent templates or guidance when the new
rule changes their expectations.

Versioning rules:
- MAJOR for backward-incompatible principle changes or removals.
- MINOR for new principles or materially expanded guidance.
- PATCH for clarifications, wording fixes, and non-semantic refinements.

Compliance is expected in every review. If a change cannot satisfy a rule, the
exception MUST be documented in the change itself.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): original adoption
date not recorded | **Last Amended**: 2026-06-04
