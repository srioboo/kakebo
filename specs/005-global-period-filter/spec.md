# Feature Specification: Selector de Período Global en Navegación

**Feature Branch**: `005-global-period-filter`
**Created**: 2026-06-21
**Status**: Draft
**Input**: User description: "quiero cambiar el listado de meses de ingresos y gastos fuera del menú actual, de forma de que tengamos un menú externo que nos permita seleccionar: mes/año actual y resto de años/meses, de forma que al seleccionar un mes/año se muestre el las pantallas actuales, general, diario, etc filtrado por el mes actual"

## Problema y Objetivos

### Problema
Actualmente el selector de año/mes está integrado dentro de cada pantalla de gastos e ingresos de forma independiente, lo que implica que navegar a otra pantalla (General, Resumen) no respeta el período elegido y el usuario tiene que seleccionar el período de nuevo en cada sección.

### Objetivos
- Ofrecer un único selector de período (año/mes) persistente en el panel de navegación lateral, visible en todo momento independientemente de la pantalla activa.
- Asegurar que al cambiar el período en el selector global, todas las pantallas con datos (General, Gastos, Ingresos) muestren información del período seleccionado.
- Eliminar los selectores de período embebidos en las pantallas de Gastos e Ingresos para evitar duplicidad.
- Mantener el comportamiento por defecto de mostrar el mes en curso al abrir la aplicación.

## Alcance

- Selector de período global ubicado en el panel de navegación lateral.
- Propagación del período seleccionado a todas las pantallas con datos: General, Gastos, Ingresos.
- Eliminación de los selectores de período embebidos en Gastos e Ingresos.
- Comportamiento por defecto: mes y año en curso al primer acceso.

## Fuera de Alcance

- Cambios en la lógica de negocio de filtrado (ya implementada en feature 004).
- Pantallas sin datos dinámicos (Diario, Resumen con datos reales — actualmente son estáticas).
- Nuevas APIs de backend — el filtrado por año/mes ya existe.
- Cambios en la estructura de datos o modelos de entidades.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Selector global visible en todo momento (Priority: P1)

Como usuario, quiero ver un selector de año/mes en el panel de navegación lateral para poder cambiar el período activo desde cualquier pantalla sin perder mi posición.

**Why this priority**: Es el requisito fundamental del cambio: consolidar el selector en un lugar único y persistente.

**Independent Test**: Al acceder a cualquier pantalla de la aplicación, el panel de navegación lateral muestra el selector de período con el mes en curso preseleccionado.

**Acceptance Scenarios**:

1. **Given** un usuario en la pantalla General, **When** abre la aplicación, **Then** el selector del panel lateral muestra el año y mes actuales como período activo.
2. **Given** un usuario en la pantalla Gastos, **When** navega a Ingresos, **Then** el selector lateral sigue mostrando el mismo período sin restablecerse.
3. **Given** el selector global visible, **When** el usuario despliega un año, **Then** aparecen los meses disponibles de ese año.

---

### User Story 2 - Período seleccionado aplicado a todas las pantallas (Priority: P1)

Como usuario, quiero que al seleccionar un año/mes en el selector global, todas las pantallas con datos (General, Gastos, Ingresos) muestren automáticamente los movimientos del período elegido.

**Why this priority**: Es el valor central del feature: que la selección de período sea única y se propague a toda la aplicación.

**Independent Test**: Al seleccionar enero de 2020 en el selector global, la pantalla General y las de Gastos e Ingresos muestran únicamente datos de ese período.

**Acceptance Scenarios**:

1. **Given** que el usuario selecciona un año/mes en el selector lateral, **When** confirma la selección, **Then** la pantalla activa se actualiza mostrando solo los datos del período seleccionado.
2. **Given** que el usuario ha seleccionado febrero de 2025 en el selector, **When** navega a la pantalla General, **Then** la pantalla General muestra ingresos y gastos de febrero de 2025.
3. **Given** que el usuario ha seleccionado un período en el selector, **When** navega de Gastos a Ingresos, **Then** Ingresos muestra datos del mismo período sin necesidad de volver a seleccionarlo.
4. **Given** que no existen datos para el período seleccionado, **When** el usuario navega a Gastos o Ingresos, **Then** se muestra un estado vacío informativo sin errores.

---

### User Story 3 - Eliminar selectores embebidos en Gastos e Ingresos (Priority: P2)

Como usuario, quiero que las pantallas de Gastos e Ingresos no muestren su propio selector de período (porque ya está disponible en el panel lateral), para que la interfaz sea más limpia y sin elementos duplicados.

**Why this priority**: Limpieza visual y consistencia UX: una vez existe el selector global, los selectores por pantalla son redundantes y confusos.

**Independent Test**: Las pantallas de Gastos e Ingresos no contienen ningún selector de período; el único selector disponible es el del panel lateral.

**Acceptance Scenarios**:

1. **Given** un usuario en la pantalla Gastos, **When** examina la interfaz, **Then** no encuentra ningún selector de año/mes en el contenido de la pantalla.
2. **Given** un usuario en la pantalla Ingresos, **When** examina la interfaz, **Then** no encuentra ningún selector de año/mes en el contenido de la pantalla.

---

### Edge Cases

- ¿Qué ocurre cuando el usuario accede directamente a una URL con parámetros de período (`?year=2020&month=1`)? El selector global debe reflejar ese período.
- ¿Qué ocurre si el usuario abre la aplicación por primera vez sin URL de período? Debe mostrarse el mes en curso.
- ¿Cómo se comporta el selector si la pantalla activa no tiene datos dinámicos (Diario)? Se aplica el `goto` pero la pantalla no cambia su contenido.
- ¿Qué pasa si el usuario selecciona un período y luego navega a otra pantalla? El período debe mantenerse en la nueva URL.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE mostrar un selector de año/mes en el panel de navegación lateral, visible desde cualquier pantalla.
- **FR-002**: El selector DEBE mostrar el año y mes en curso como período activo por defecto al abrir la aplicación.
- **FR-003**: El selector DEBE permitir al usuario expandir un año para ver sus meses y seleccionar un mes concreto.
- **FR-004**: Cuando el usuario selecciona un período en el selector global, el sistema DEBE navegar a la URL de la pantalla activa con los parámetros de año y mes correspondientes.
- **FR-005**: Las pantallas General, Gastos e Ingresos DEBEN leer el período de los parámetros de URL y mostrar únicamente los datos del período seleccionado.
- **FR-006**: El sistema DEBE mantener el período seleccionado al navegar entre pantallas (persiste en la URL).
- **FR-007**: Las pantallas de Gastos e Ingresos NO DEBEN mostrar su propio selector de período embebido.
- **FR-008**: El selector global DEBE reflejar el período activo cuando el usuario accede con parámetros de período en la URL.

### Non-Functional Requirements

- **NFR-001**: El selector de período no debe obstaculizar la navegación principal (General, Diario, Gastos, Ingresos, Resumen).
- **NFR-002**: El cambio de período debe ser instantáneo desde la perspectiva del usuario — la pantalla se actualiza sin navegación perceptible fuera de la pantalla activa.
- **NFR-003**: El comportamiento debe ser consistente en todas las pantallas con datos dinámicos.

### Key Entities *(include if feature involves data)*

- **Período activo**: El año y mes actualmente seleccionados, representados como parámetros de URL (`?year=Y&month=M`).
- **Panel de navegación lateral**: La barra de navegación persistente que contiene los vínculos a las secciones de la app y alojará el selector global.
- **Pantallas con datos dinámicos**: General (`/`), Gastos (`/expenses`), Ingresos (`/incomes`) — pantallas que consumen datos filtrados por período.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de las pantallas con datos dinámicos (General, Gastos, Ingresos) muestran únicamente datos del período seleccionado en el selector global.
- **SC-002**: El selector de período aparece en el 100% de las pantallas de la aplicación sin requerir interacción adicional del usuario.
- **SC-003**: El período seleccionado se mantiene al navegar entre las pantallas General, Gastos e Ingresos en el 100% de los casos.
- **SC-004**: Las pantallas de Gastos e Ingresos no contienen selectores de período embebidos en el 100% de los casos tras este feature.
- **SC-005**: El mes en curso es el período activo por defecto en el 100% de los accesos sin parámetros de URL.

## Assumptions

- El backend ya soporta filtrado por año/mes en los endpoints de gastos e ingresos (implementado en feature 004).
- La pantalla Diario no consume datos dinámicos y no requiere filtrado por período en esta iteración.
- La pantalla Resumen actualmente usa datos estáticos/de ejemplo y no requiere filtrado por período en esta iteración.
- El panel de navegación lateral (AppRail) tiene espacio suficiente para alojar el selector sin afectar a la usabilidad de los vínculos de navegación.
- El período seleccionado se propaga mediante parámetros de URL, lo que garantiza compatibilidad con SSR y navegación directa por URL.
