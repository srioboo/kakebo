# Feature Specification: API-First Contract and Project Wiki

**Feature Branch**: `001-api-first-wiki`  
**Created**: 2026-06-04  
**Status**: Draft  
**Input**: User description: "implementar el api first en el proyecto para el uso de un contrato unico entre backend y frontend y documentar el estado actual del proyecto en una carpeta docs a modo de wiki y utilización del proyecto."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Single Source of Truth (Priority: P1)

As a maintainer, I want one shared contract for backend and frontend so that
changes in data shape, endpoints, or usage are coordinated from a single place.

**Why this priority**: This is the core of the API-first goal and prevents
backend/frontend drift.

**Independent Test**: A reviewer can trace the public project contract in one
place and confirm that both sides refer to it instead of keeping separate,
conflicting descriptions.

**Acceptance Scenarios**:

1. **Given** a planned change to data exchanged between backend and frontend,
   **When** the change is documented, **Then** the contract is updated once and
   becomes the reference point for both sides.
2. **Given** a contributor is checking the current interface, **When** they look
   for the source of truth, **Then** they find a single contract instead of
   multiple competing descriptions.

---

### User Story 2 - Project Wiki for Current State (Priority: P2)

As a new or returning contributor, I want a wiki-style documentation area that
summarizes the current state of the project so I can understand how the project
is organized and how to use it.

**Why this priority**: Good documentation reduces onboarding friction and makes
the current project status easy to understand without asking for help.

**Independent Test**: A contributor can open the docs area and find the current
project overview, usage guidance, and the main places to look for backend and
frontend work.

**Acceptance Scenarios**:

1. **Given** I am new to the repository, **When** I open the docs area, **Then**
   I can find the project overview, setup guidance, and where to go next.
2. **Given** I need usage instructions, **When** I look in the docs area, **Then**
   I can find commands and notes that help me run and understand the project.

---

### User Story 3 - Consistent Guidance Across the Repo (Priority: P3)

As a maintainer, I want documentation and contract references to stay aligned
with the project’s current state so that users do not find conflicting guidance.

**Why this priority**: The docs are most useful when they stay synchronized with
the active project structure and expectations.

**Independent Test**: A contributor can compare the top-level wiki guidance with
the project’s active backend and frontend documentation and see a consistent
story.

**Acceptance Scenarios**:

1. **Given** the project evolves, **When** a document changes, **Then** the
   wiki remains consistent with the current behavior and major repository areas.
2. **Given** a contributor follows the docs, **When** they move between project
   areas, **Then** they are not sent to conflicting or outdated instructions.

---

### Edge Cases

- What happens when backend and frontend documentation disagree with the shared
  contract?
- How does the docs area present project parts that are intentionally out of
  scope, such as the separate admin project?
- What happens when a project area is active but not yet fully documented?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The project MUST define a single authoritative contract for the
  backend/frontend interface.
- **FR-002**: The project MUST make the contract easy to find from the main
  documentation entry point.
- **FR-003**: The project MUST provide a docs area that explains the current
  project state in a wiki-like format.
- **FR-004**: The docs area MUST include how to use the project, how to start
  it, and where the main backend and frontend responsibilities live.
- **FR-005**: The docs area MUST clearly separate active project guidance from
  out-of-scope or separate projects.
- **FR-006**: Contract and docs updates MUST remain consistent so users do not
  receive contradictory guidance.
- **FR-007**: The documentation structure MUST support quick onboarding for new
  contributors and quick reference for returning contributors.

### Key Entities *(include if feature involves data)*

- **API Contract**: The shared source of truth for the backend/frontend
  interface.
- **Project Wiki Page**: A documentation entry that describes state, usage, and
  navigation.
- **Project State Snapshot**: The current summary of what parts of the project
  are active, where they live, and how they are used.
- **Usage Guide**: The practical instructions a contributor follows to run and
  work with the project.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A contributor can identify the shared contract and the project
  wiki entry point in under 2 minutes.
- **SC-002**: At least 90% of onboarding participants can find setup, usage,
  and project structure guidance without direct help.
- **SC-003**: The docs area covers all active project areas with no conflicting
  instructions for the primary workflow.
- **SC-004**: Reviewers can confirm whether a change affects the shared
  contract or the project wiki from the documentation alone.

## Assumptions

- The new wiki-style docs area is intended for the main repository, not only for
  a single subproject.
- The separate admin project remains out of scope unless explicitly added later.
- Existing detailed backend documentation remains useful and can be referenced
  from the new wiki.
- The shared contract is the existing backend/frontend interface used by the web
  app.
