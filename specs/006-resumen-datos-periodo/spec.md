# Feature Specification: Resumen con Datos Reales por Período

**Feature Branch**: `006-resumen-datos-periodo`
**Created**: 2026-06-21
**Status**: Draft
**Input**: User description: "la ruta de resumen debe cambiar al pulsar uno de los meses y obtener los datos de ingresos, gastos y ahorros de ese mes."

## Problema y Objetivos

### Problema

La pantalla Resumen (`/resumen`) actualmente muestra datos estáticos y no reacciona al selector de período global. El usuario no puede ver un resumen financiero real de un mes concreto: al seleccionar enero de 2020 en el selector lateral, la pantalla Resumen sigue mostrando los mismos valores de ejemplo fijos.

### Objetivos

- Conectar la pantalla Resumen al selector de período global, de modo que responda a la selección de año/mes igual que las pantallas General, Gastos e Ingresos.
- Mostrar en la pantalla Resumen los datos financieros reales del período seleccionado: total de ingresos, total de gastos, ahorro resultante y tasa de ahorro.
- Reemplazar los valores de ejemplo fijos por métricas calculadas dinámicamente a partir de los movimientos del período.

## Alcance

- La pantalla Resumen (`/resumen`) reacciona al período seleccionado en el selector lateral y actualiza su URL con los parámetros de año/mes.
- La pantalla Resumen muestra los siguientes datos para el período seleccionado:
  - **Total de ingresos**: suma de todos los ingresos del período.
  - **Total de gastos**: suma de todos los gastos del período.
  - **Ahorro**: diferencia entre ingresos y gastos (puede ser negativo).
  - **Tasa de ahorro**: porcentaje del ahorro respecto a los ingresos totales.
- Los datos se obtienen del sistema de registro de ingresos y gastos ya existente.

## Fuera de Alcance

- Cambios en el backend — los endpoints de filtrado por año/mes ya existen (feature 004).
- Desglose por categorías de gastos en la pantalla Resumen — solo se muestran totales.
- Pantalla Diario — no consume datos dinámicos.
- Exportación o descarga de datos del resumen.
- Comparativa entre períodos (este mes vs. mes anterior).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Resumen responde al selector de período (Priority: P1) 🎯 MVP

Como usuario, quiero que la pantalla Resumen se actualice automáticamente cuando selecciono un período en el selector lateral, para ver siempre el resumen del mes que he elegido sin tener que navegar manualmente.

**Why this priority**: Es el requisito base: sin navegación por período, el resumen no tiene utilidad dinámica.

**Independent Test**: Al seleccionar enero de 2020 en el selector lateral desde la pantalla Resumen, la URL cambia a `/resumen?year=2020&month=1` y el encabezado muestra "Resumen mensual · Enero 2020".

**Acceptance Scenarios**:

1. **Given** un usuario en la pantalla Resumen, **When** selecciona febrero de 2025 en el selector lateral, **Then** la URL cambia a `/resumen?year=2025&month=2` y el encabezado refleja ese período.
2. **Given** la pantalla Resumen con un período activo, **When** el usuario navega a otra pantalla y vuelve, **Then** el período sigue activo en la URL.
3. **Given** que el usuario accede directamente a `/resumen?year=2024&month=3`, **Then** la pantalla muestra el resumen de marzo de 2024.
4. **Given** que no se proporcionan parámetros de período, **Then** la pantalla muestra el resumen del mes en curso.

---

### User Story 2 - Datos reales de ingresos, gastos y ahorros (Priority: P1)

Como usuario, quiero ver los datos financieros reales del período seleccionado en la pantalla Resumen, para entender mi situación económica de ese mes concreto.

**Why this priority**: Es el valor principal del feature: sustituir los valores de ejemplo por datos reales.

**Independent Test**: Con ingresos de 2.000 EUR y gastos de 1.500 EUR registrados para el período seleccionado, la pantalla Resumen muestra: Ingresos 2.000 EUR, Gastos 1.500 EUR, Ahorro 500 EUR, Tasa de ahorro 25%.

**Acceptance Scenarios**:

1. **Given** un período con ingresos y gastos registrados, **When** el usuario accede a la pantalla Resumen, **Then** se muestran los totales reales de ingresos, gastos, ahorro y tasa de ahorro.
2. **Given** un período sin movimientos registrados, **When** el usuario accede a la pantalla Resumen, **Then** se muestran todos los valores a cero (0 EUR y 0%) sin errores.
3. **Given** un período con ingresos pero sin gastos, **When** el usuario accede a la pantalla Resumen, **Then** el ahorro es igual a los ingresos y la tasa de ahorro es 100%.
4. **Given** un período donde los gastos superan los ingresos, **When** el usuario accede a la pantalla Resumen, **Then** el ahorro muestra un valor negativo.
5. **Given** un período con ingresos a cero, **When** el sistema calcula la tasa de ahorro, **Then** la tasa de ahorro se muestra como 0% (sin división por cero).

---

### Edge Cases

- ¿Qué ocurre si el backend falla al obtener datos? La pantalla debe mostrar un mensaje de error claro y no valores incorrectos.
- ¿Qué ocurre si la tasa de ahorro supera el 100% (no hay gastos)? Se muestra el porcentaje real sin truncar.
- ¿Qué ocurre si un valor negativo de ahorro genera una tasa negativa? Se muestra el valor negativo sin modificar.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La pantalla Resumen DEBE leer los parámetros de año/mes de la URL y mostrar los datos del período correspondiente.
- **FR-002**: Cuando no se proporcionan parámetros de período, la pantalla Resumen DEBE mostrar el mes en curso por defecto.
- **FR-003**: Cuando el usuario selecciona un período en el selector lateral estando en **cualquier pantalla** de la aplicación (General, Gastos, Ingresos, Resumen), el sistema DEBE navegar inmediatamente a la misma pantalla con los nuevos parámetros de período y recargar los datos — sin requerir ninguna recarga manual del navegador ni acción adicional del usuario.
- **FR-004**: La pantalla Resumen DEBE mostrar el total de ingresos del período seleccionado, calculado como la suma de todos los registros de ingresos de ese mes y año.
- **FR-005**: La pantalla Resumen DEBE mostrar el total de gastos del período seleccionado, calculado como la suma de todos los registros de gastos de ese mes y año.
- **FR-006**: La pantalla Resumen DEBE mostrar el ahorro del período como la diferencia entre el total de ingresos y el total de gastos (puede ser negativo).
- **FR-007**: La pantalla Resumen DEBE mostrar la tasa de ahorro como el porcentaje que representa el ahorro sobre el total de ingresos; si los ingresos son cero, la tasa de ahorro DEBE ser 0%.
- **FR-008**: Cuando no existen movimientos para el período seleccionado, la pantalla Resumen DEBE mostrar todos los valores numéricos a cero sin mostrar errores.
- **FR-009**: Si el sistema no puede obtener los datos del período, la pantalla Resumen DEBE mostrar un banner de error inline por encima de las tarjetas de métricas, siguiendo el mismo patrón visual que las pantallas Gastos e Ingresos.
- **FR-010**: El encabezado de la pantalla Resumen DEBE actualizarse dinámicamente con el formato "Resumen mensual · [Mes] [Año]" (e.g., "Resumen mensual · Enero 2026") para reflejar el período activo.
- **FR-011**: Los totales de ingresos, gastos, ahorro y tasa de ahorro DEBEN calcularse en el servidor (`+page.server.ts`) y entregarse pre-computados al componente de página — el componente solo renderiza valores, sin cálculos derivados en el cliente. Esto garantiza que cualquier cambio de período (que dispara una nueva ejecución del `load`) actualiza automáticamente todos los valores sin depender de reactividad en el cliente.

### Non-Functional Requirements

- **NFR-001**: Los datos de cualquier pantalla DEBEN actualizarse en la misma interacción de clic (al pulsar el mes en el selector lateral), sin requerir recarga manual de la página, pulsación de Enter, ni ninguna otra acción del usuario.
- **NFR-002**: Los valores monetarios DEBEN mostrarse con el mismo formato que el resto de la aplicación.
- **NFR-003**: La tasa de ahorro DEBE mostrarse con exactamente un decimal (e.g., "24,6%").
- **NFR-004**: Mientras se obtienen los datos del período (durante la navegación), la pantalla Resumen DEBE mostrar skeleton placeholders que repliquen la forma de las cuatro tarjetas de métricas (Ingresos, Gastos, Ahorro, Tasa de ahorro) — no un spinner global ni datos del período anterior.

### Key Entities *(include if feature involves data)*

- **Período activo**: Año y mes representados como parámetros de URL (`?year=Y&month=M`).
- **Total de ingresos**: Suma de los campos `amount` de todos los registros de ingreso del período.
- **Total de gastos**: Suma de los campos `amount` de todos los registros de gasto del período.
- **Ahorro**: Total de ingresos − Total de gastos.
- **Tasa de ahorro**: (Ahorro / Total de ingresos) × 100; resultado 0 si los ingresos son 0.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de las métricas (ingresos, gastos, ahorro, tasa de ahorro) mostradas en la pantalla Resumen corresponden a los datos reales del período seleccionado.
- **SC-002**: Al pulsar un mes en el selector lateral desde cualquier pantalla, los datos de esa pantalla se actualizan automáticamente en el mismo clic — verificable observando que los valores cambian sin que el usuario recargue la página manualmente.
- **SC-003**: El 100% de los períodos sin datos muestra valores a cero sin errores ni pantallas en blanco.
- **SC-004**: El período activo persiste en la URL al navegar entre pantallas y al recargar la página.

## Clarifications

### Session 2026-06-21

- Q: ¿Debe el cambio de datos producirse al pulsar el mes sin ninguna acción manual adicional? → A: Sí, el cambio debe ser inmediato al pulsar el mes — no se debe requerir recarga manual de la página ni ninguna otra acción.

### Session 2026-06-22

- Q: Durante la carga de datos del período, ¿qué debe mostrar la pantalla Resumen? → A: Skeleton placeholders que repliquen la forma de las cuatro tarjetas de métricas (Ingresos, Gastos, Ahorro, Tasa de ahorro).
- Q: ¿Cómo debe mostrarse el error cuando el backend falla al obtener datos? → A: Banner de error inline por encima de las tarjetas de métricas, siguiendo el mismo patrón visual que las pantallas Gastos e Ingresos.
- Q: ¿Debe el encabezado de la pantalla Resumen actualizarse para reflejar el período activo? → A: Sí, formato "Resumen mensual · [Mes] [Año]" (e.g., "Resumen mensual · Enero 2026").
- Q: ¿Dónde deben calcularse los totales (ingresos, gastos, ahorro, tasa de ahorro) para garantizar que se actualicen al cambiar de período sin necesitar recarga manual? → A: En el servidor (`+page.server.ts`), pre-computados antes de llegar al componente de página.

## Assumptions

- Los endpoints de filtrado por año/mes para ingresos (`GET /incomes?year=Y&month=M`) y gastos (`GET /expenses?year=Y&month=M`) ya existen y funcionan correctamente (implementados en feature 004).
- El selector de período global en el panel lateral ya está implementado (feature 005) y propaga el período mediante parámetros de URL.
- La pantalla Resumen comparte el mismo mecanismo de propagación de período que General, Gastos e Ingresos: URL params como fuente de verdad.
- El formato de moneda y las utilidades de formateo ya existen en el frontend y se reutilizarán.
- Los totales (ingresos, gastos, ahorro, tasa de ahorro) se calculan en `+page.server.ts` y se devuelven pre-computados al componente de página; el componente solo renderiza — sin cálculos derivados en el cliente (ver FR-011). No se requiere un nuevo endpoint de backend.
