# Feature Specification: Filtros por Año y Mes en Movimientos

**Feature Branch**: `004-add-month-year-filters`  
**Created**: 2026-06-14  
**Status**: Draft  
**Input**: User description: "Actualmente el frontend solo muestra el mes en curso. Actualizar la API para que pueda filtrar por meses. En el frontend incluir filtros por meses en ingresos y gastos para mostrar el mes en curso o meses anteriores. En general, por defecto mostrar el mes en curso, pero añadir submenús para los años incluyendo el año actual y en cada año añadir un submenú para los meses."

## Problema y Objetivos

### Problema
Actualmente la consulta y visualización de movimientos está limitada al mes en curso, lo que impide revisar de forma directa ingresos y gastos de meses anteriores.

### Objetivos
- Permitir filtrar movimientos por período (año y mes) desde API y frontend.
- Mantener como comportamiento por defecto la vista del mes en curso.
- Facilitar navegación histórica mediante submenús por año y por mes.
- Aplicar el mismo comportamiento de filtrado en ingresos y en gastos.

## Alcance

- Filtro temporal por año y mes para consultar movimientos.
- Menú jerárquico de selección: años disponibles (incluyendo año actual) y meses dentro de cada año.
- Aplicación consistente del filtro en vistas/listados de ingresos y gastos.
- Carga inicial por defecto en mes en curso.

## Fuera de Alcance

- Cambios en categorías, reglas de negocio de cálculo o edición de movimientos.
- Reportes analíticos avanzados fuera de la selección temporal básica.
- Migraciones históricas o corrección de datos previos.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ver movimientos del mes actual por defecto (Priority: P1)

Como usuario, quiero que al abrir ingresos o gastos se muestre automáticamente el mes en curso para ver mi estado financiero actual sin pasos adicionales.

**Why this priority**: Es el flujo principal y mantiene la experiencia actual esperada, evitando fricción al entrar en la aplicación.

**Independent Test**: Se valida ingresando a ingresos y gastos sin aplicar filtros manuales y comprobando que ambos muestran datos del mes y año actuales.

**Acceptance Scenarios**:

1. **Given** un usuario autenticado con movimientos en distintos meses, **When** abre la sección de ingresos, **Then** se muestran solo ingresos del mes en curso.
2. **Given** un usuario autenticado con movimientos en distintos meses, **When** abre la sección de gastos, **Then** se muestran solo gastos del mes en curso.

---

### User Story 2 - Consultar meses anteriores desde submenús por año/mes (Priority: P1)

Como usuario, quiero elegir un año y un mes desde submenús para consultar movimientos históricos sin cambiar de pantalla.

**Why this priority**: Habilita el valor central solicitado: revisión histórica ordenada por período.

**Independent Test**: Se valida seleccionando años y meses diferentes y comprobando que el contenido de ingresos y gastos se actualiza al período elegido.

**Acceptance Scenarios**:

1. **Given** que existen movimientos de más de un año, **When** el usuario abre el submenú de años, **Then** visualiza al menos el año actual y los años con datos disponibles.
2. **Given** que el usuario selecciona un año específico, **When** abre su submenú de meses, **Then** visualiza los meses disponibles para ese año.
3. **Given** que el usuario selecciona año y mes, **When** confirma esa selección, **Then** los listados muestran exclusivamente los movimientos del período seleccionado.

---

### User Story 3 - Consistencia de filtros en ingresos y gastos (Priority: P2)

Como usuario, quiero que el comportamiento del filtro temporal sea consistente entre ingresos y gastos para evitar confusión y comparar períodos con el mismo criterio.

**Why this priority**: Reduce errores de interpretación y mejora la confianza en la información financiera mostrada.

**Independent Test**: Se valida aplicando el mismo año/mes en ingresos y gastos y comprobando que ambos módulos reflejan el período seleccionado.

**Acceptance Scenarios**:

1. **Given** un período seleccionado en ingresos, **When** el usuario navega a gastos y aplica el mismo período, **Then** ambos módulos muestran resultados del mismo año/mes sin comportamientos divergentes.
2. **Given** que se restablece la selección temporal, **When** se vuelve al estado por defecto, **Then** ingresos y gastos retornan al mes en curso.

---

### Edge Cases

- ¿Qué ocurre cuando para un año seleccionado no existen movimientos en uno o más meses?
- ¿Qué ocurre cuando no hay ningún movimiento en el mes en curso?
- ¿Cómo se comporta la UI cuando solo existe información de un único año y/o un único mes?
- ¿Qué ocurre si se solicita por API un mes inválido (fuera de 1–12) o un año fuera de rango soportado?
- ¿Cómo se refleja en frontend una respuesta vacía para el período seleccionado?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE permitir consultar movimientos filtrando por año y mes.
- **FR-002**: El sistema DEBE considerar el mes en curso como filtro predeterminado cuando no se indique un período explícito.
- **FR-003**: El sistema DEBE ofrecer en la interfaz un submenú de años que incluya el año actual y los años con movimientos disponibles.
- **FR-004**: El sistema DEBE ofrecer, dentro de cada año, un submenú de meses para seleccionar el período exacto a visualizar.
- **FR-005**: El sistema DEBE aplicar el filtro temporal de forma equivalente en los módulos de ingresos y gastos.
- **FR-006**: El sistema DEBE actualizar los listados de ingresos y gastos al período seleccionado sin requerir navegación a otra pantalla.
- **FR-007**: El sistema DEBE devolver una respuesta vacía y válida (sin error funcional) cuando no existan movimientos en el período seleccionado.
- **FR-008**: El sistema DEBE rechazar solicitudes con valores de mes o año inválidos, informando al consumidor que el filtro no es válido.

### Non-Functional Requirements

- **NFR-001**: La selección de año y mes debe resultar comprensible para usuarios no técnicos en la primera interacción.
- **NFR-002**: El tiempo de actualización percibido del listado al cambiar de período debe ser lo suficientemente rápido para no interrumpir el flujo de consulta.
- **NFR-003**: La consistencia visual y de comportamiento entre ingresos y gastos debe mantenerse en todos los estados del filtro (por defecto, seleccionado, sin resultados, error de validación).

### Key Entities *(include if feature involves data)*

- **Período de Consulta**: Representa el rango temporal puntual de filtrado (año + mes) usado para consultar movimientos.
- **Movimiento Financiero**: Registro de ingreso o gasto asociado a una fecha que determina su pertenencia a un período de consulta.
- **Catálogo de Años/Meses Disponibles**: Conjunto de valores temporales navegables que el usuario puede seleccionar para filtrar.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: En al menos el 95% de aperturas de ingresos y gastos, los usuarios visualizan correctamente el mes en curso sin realizar acciones adicionales.
- **SC-002**: El 100% de las selecciones válidas de año/mes actualizan los listados al período elegido en ingresos y gastos.
- **SC-003**: Al menos el 90% de usuarios en pruebas de aceptación completa una consulta de mes histórico en menos de 3 interacciones.
- **SC-004**: Los errores por filtros temporales inválidos se presentan de forma clara y permiten corrección sin abandonar el flujo en el 100% de los casos probados.

## Assumptions

- Los movimientos financieros existentes incluyen fecha suficiente para identificar año y mes de forma inequívoca.
- La aplicación ya diferencia correctamente entre ingresos y gastos y ambos módulos consumen datos de movimientos.
- El filtro temporal requerido es de granularidad mensual; no se requiere día, trimestre ni rango personalizado para este alcance.
- La visualización histórica se limita a períodos con datos o períodos seleccionables definidos por el sistema.
