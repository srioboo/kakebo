# Feature Specification: Java Runtime Switch for Dev Startup

**Feature Branch**: `003-sdkman-java-switch`  
**Created**: 2026-06-07  
**Status**: Draft  
**Input**: User description: "el sistema emplea diferentes versiones de java, cuando se ejecute dev.sh habría que cambiar a la versión adecuada de java. Se está usando sdkman actualmente. Investiga la mejor opción para lanzar el java adecuado al lanzar la aplicación, bien usando sdkman u otra opción"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatic Java Selection (Priority: P1)

As a developer, I want the startup helper to use the project’s required Java
version automatically so that I do not have to switch versions manually before
starting the app.

**Why this priority**: The wrong Java version blocks local startup and creates
avoidable setup friction.

**Independent Test**: A developer can run the normal startup command and see
that the application starts with the project’s intended Java version without
manually changing their shell environment first.

**Acceptance Scenarios**:

1. **Given** the required Java version is installed, **When** I start the
   development environment, **Then** the helper activates that Java version
   before launching the app.
2. **Given** a different Java version is currently active, **When** I start the
   development environment, **Then** the helper switches to the project version
   automatically before continuing.

---

### User Story 2 - Clear Java Setup Guidance (Priority: P2)

As a developer, I want clear instructions when the required Java version is not
available so that I can install or activate the correct version quickly.

**Why this priority**: Local Java setup failures should lead to an actionable
next step rather than a confusing startup error.

**Independent Test**: A developer who does not have the required Java version
can see explicit guidance for the supported Java manager and how to prepare the
runtime.

**Acceptance Scenarios**:

1. **Given** the required Java version is missing, **When** I start the
   development environment, **Then** I see a clear message explaining how to
   install or activate it.
2. **Given** the Java manager is not available, **When** I start the helper,
   **Then** I am told what prerequisite is missing and how to resolve it.

---

### User Story 3 - Documented Startup Behavior (Priority: P3)

As a maintainer, I want the Java-switching behavior to be documented alongside
the development startup instructions so that contributors understand what the
helper does.

**Why this priority**: The automatic Java switch is part of the local dev
experience and should be visible in the main docs.

**Independent Test**: A contributor can read the main documentation and know
that the helper will select the correct Java version before starting the app.

**Acceptance Scenarios**:

1. **Given** I open the repository-level docs, **When** I look for startup
   instructions, **Then** I can see that the helper manages Java version
   selection automatically.
2. **Given** I want to troubleshoot startup, **When** I read the docs, **Then**
   I can find the Java requirement and the recovery path for missing versions.

---

### Edge Cases

- What happens when the Java manager is installed but the required Java version
  is not?
- What happens when the helper cannot change Java because the current shell does
  not support the manager?
- What happens when the Java version is correct but the app still fails for a
  separate reason?
- What happens when multiple supported Java versions are available locally?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The development startup flow MUST ensure the project’s required
  Java version is active before launching the application.
- **FR-002**: The startup flow MUST prefer the repository’s standard Java
  version management approach when it is available locally.
- **FR-003**: If the active Java version does not match the project requirement,
  the startup flow MUST switch to the project version automatically or stop with
  a clear explanation if switching is not possible.
- **FR-004**: If the required Java version is missing, the startup flow MUST
  show an actionable message that explains how to install or activate it.
- **FR-005**: The startup flow MUST continue with the application only after the
  correct Java version is active.
- **FR-006**: The documented development instructions MUST describe the Java
  requirement and the automatic version-selection behavior.
- **FR-007**: The startup experience MUST remain simple enough to use as the
  normal entry point for local development.

### Key Entities *(include if feature involves data)*

- **Project Java Version**: The Java version required by the backend project.
- **Java Manager**: The local version-management tool used to activate the
  correct runtime.
- **Startup Preflight**: The check that confirms the right Java version before
  app startup.
- **Recovery Guidance**: The message shown when the required Java version is
  missing or cannot be activated.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can start the app without manually changing their
  Java version first.
- **SC-002**: Java version mismatches no longer block startup when the required
  version is installed locally.
- **SC-003**: A developer missing the required version receives a clear next
  step instead of a generic startup failure.
- **SC-004**: The main startup docs describe the automatic Java selection
  behavior clearly enough for a new contributor to understand it.

## Assumptions

- SDKMAN is the preferred local Java manager because it is already in use in the
  environment.
- The project should treat the backend’s declared Java version as the source of
  truth for startup selection.
- The `dev.sh` startup path is the primary target for this feature.
- The separate Windows helper remains out of scope unless explicitly added
  later.
