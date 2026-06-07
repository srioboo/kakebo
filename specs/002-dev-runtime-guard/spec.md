# Feature Specification: Dev Runtime Guard

**Feature Branch**: `002-dev-runtime-guard`  
**Created**: 2026-06-06  
**Status**: Draft  
**Input**: User description: "los script de desarrollo no comprueban si está funcionando docker o podman al iniciar. Necesito que: - verifique si los docker necesarios están activo - sino mostrar al usuario como arrancar docker o podman, usando un selector de opciones en el cli - arrancar docker y activar el docker adecuado para el correcto funcionamiento de la aplicación"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Runtime Ready Check (Priority: P1)

As a developer, I want the development startup flow to verify whether the
required container runtime is already running so that I do not waste time
starting the app only to fail later.

**Why this priority**: Startup reliability is the core problem and blocks all
other development workflows.

**Independent Test**: A developer can launch the normal development entry point
and immediately see whether the runtime is ready before the app tries to start.

**Acceptance Scenarios**:

1. **Given** the required container runtime is already active, **When** I start
   the development environment, **Then** the startup continues without asking me
   to take extra runtime steps.
2. **Given** the required container runtime is not active, **When** I start the
   development environment, **Then** I am informed that the runtime must be
   started first.

---

### User Story 2 - Guided Runtime Selection (Priority: P2)

As a developer, I want a CLI selector to choose how to start the runtime when it
is not available so that I can follow the correct path without guessing.

**Why this priority**: Developers need clear choices when multiple runtime
options exist.

**Independent Test**: A developer can reach a prompt that offers the available
runtime options and provides clear next steps for the selected choice.

**Acceptance Scenarios**:

1. **Given** no supported runtime is active, **When** I open the startup flow,
   **Then** I am shown a selector with the supported runtime options.
2. **Given** I choose one runtime option, **When** I continue, **Then** I see
   the matching instructions for starting that runtime on my machine.

---

### User Story 3 - Successful App Startup (Priority: P3)

As a developer, I want the startup flow to activate the appropriate runtime and
then start the application successfully so that I can begin working right away.

**Why this priority**: The startup flow is only useful if it ends with a
working development environment.

**Independent Test**: A developer can follow the guided flow from a stopped
runtime to a running backend and frontend without manual trial and error.

**Acceptance Scenarios**:

1. **Given** I select a supported runtime path, **When** I follow the startup
   flow, **Then** the runtime is started or activated and the app begins.
2. **Given** the environment is already ready, **When** I use the startup flow,
   **Then** the app starts directly and remains usable for normal development.

---

### Edge Cases

- What happens when both supported runtimes are installed?
- What happens when neither runtime is installed or available to start?
- What happens when the runtime is installed but the user lacks permission to
  start it?
- What happens when a developer cancels the selector before choosing a runtime?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The development startup flow MUST verify whether a supported
  container runtime is already active before starting the application.
- **FR-002**: If no supported runtime is active, the startup flow MUST tell the
  developer that runtime startup is required before proceeding.
- **FR-003**: When multiple supported runtime options are available, the startup
  flow MUST present a CLI selector so the developer can choose one.
- **FR-004**: The guidance shown after selection MUST explain how to start the
  chosen runtime on the current machine.
- **FR-005**: The startup flow MUST activate or connect to the selected runtime
  path before launching the application.
- **FR-006**: The startup flow MUST stop with a clear message if the selected
  runtime cannot be started or accessed.
- **FR-007**: The developer-facing startup experience MUST remain simple enough
  to use as the normal entry point for local development.

### Key Entities *(include if feature involves data)*

- **Development Startup Flow**: The user-facing entry point that prepares the
  local environment and launches the app.
- **Runtime Choice**: The supported container runtime option the developer
  selects when startup assistance is needed.
- **Runtime Status**: The current readiness state of the required container
  runtime.
- **Startup Guidance**: The instructions shown to help the developer bring the
  selected runtime online.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can tell whether the container runtime is ready
  before the application startup proceeds.
- **SC-002**: A developer who needs help can choose a runtime path without
  leaving the terminal.
- **SC-003**: Most local startup attempts no longer fail because the runtime was
  not active beforehand.
- **SC-004**: The normal development entry point leads to a working local app
  after the runtime is ready.

## Assumptions

- The development helper scripts are the primary entry points for local
  startup.
- The feature applies to both operating system paths used by the repository
  helper scripts.
- The selector is intended to help developers choose between supported runtime
  options, not to replace the runtime itself.
- The separate admin project remains out of scope unless explicitly added
  later.
