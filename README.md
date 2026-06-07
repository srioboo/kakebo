# Kakebo - Sistema de Finanzas Personales 💰

> Docs hub: `docs/README.md` — primary project documentation and API contract (`docs/api-contract.md`).

Aplicación web para gestionar ingresos y gastos basada en el método **Kakebo** (家計簿) japonés.

**Stack**: Spring Boot 3.x (backend) + SvelteKit 2 (frontend) + PostgreSQL/H2

---

## 🚀 Quick Start (5 minutos)

### Requisitos Previos
- **Java 21+** - Para Spring Boot (`java -version`)
- **Node.js 18+** - Para SvelteKit (`node -v`)
- **npm** - Gestor de paquetes (`npm -v`)

### ⚡ La Forma Más Rápida

```bash
# Posiciónate en la raíz del proyecto
cd kakebo

# macOS/Linux: Usa el script helper
./dev.sh start

# Windows: Usa el batch script
dev.bat start
```

> `dev.sh start` y `dev.bat start` comprueban Docker/Podman al inicio y muestran un selector si hace falta arrancar el runtime.

**¡Listo!** Abre tu navegador:
- 🌐 Frontend: http://localhost:5173
- 🔗 Backend: http://localhost:9090
- 📚 Swagger: http://localhost:9090/swagger-ui.html

> **Nota**: El primer inicio descargará dependencias (puede tardar 1-2 minutos)

### 📖 Si Prefieres Configurar Manualmente

**Terminal 1: Backend**
```bash
cd kakebo-backend
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

**Terminal 2: Frontend (en otra terminal)**
```bash
cd kakebo-front
npm install --legacy-peer-deps
npm run dev
```

---

## 📋 Flujo Completo de Desarrollo

### ⚡ Opción 1: Automatizado (Recomendado)

Tenemos scripts helper para simplificar el desarrollo:

**macOS/Linux:**
```bash
# Inicia backend y frontend automáticamente
./dev.sh start

# Otras opciones disponibles
./dev.sh start-backend    # Solo backend
./dev.sh start-frontend   # Solo frontend
./dev.sh status           # Ver estado de servicios
./dev.sh stop             # Detener todo
./dev.sh restart          # Reiniciar todo
```

**Windows:**
```bash
# Inicia backend y frontend en nuevas ventanas
dev.bat start

# Otras opciones disponibles
dev.bat start-backend     # Solo backend
dev.bat start-frontend    # Solo frontend
dev.bat status            # Ver estado de servicios
dev.bat stop              # Detener todo
dev.bat restart           # Reiniciar todo
```

### 📱 Opción 2: Manual (Control Total)

Abre 2 terminales:

**Terminal 1: Backend**
```bash
cd kakebo-backend
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

**Terminal 2: Frontend**
```bash
cd kakebo-front
npm run dev
```

### 🔍 Opción 3: Monitoreo

```bash
# Ver logs del backend
tail -f /tmp/kakebo-backend.log

# Ver logs del frontend
tail -f /tmp/kakebo-frontend.log

# Verificar estado de API
curl -s http://localhost:9090/expenses | jq '.' | head -20
```

---

## 🗺️ Estructura del Proyecto

```
kakebo/
├── README.md ...................... Este archivo
├── kakebo-backend/
│   ├── README.md .................. Docs backend
│   ├── docs/
│   │   ├── 00_INDEX.md ........... Índice completo
│   │   ├── 01-Inicio-rapido.md
│   │   ├── 02-Arquitectura-hexagonal-patrones.md
│   │   ├── 03-Desarrollo-entornos-configuracion.md
│   │   ├── 04-Testing-patrones-errores-comunes.md
│   │   ├── 05-CalidadCodigo-sonarqube-cobertura.md
│   │   └── 06-Referencia-diagramas-visuales.md
│   ├── AGENTS.md .................. Instrucciones para IA
│   ├── pom.xml
│   ├── Makefile ................... Comandos útiles
│   ├── src/main/java/org/sirantar/kakebo/
│   │   ├── expenses/
│   │   │   ├── domain/model/Expenses.java
│   │   │   ├── domain/repository/ExpensesRepository.java
│   │   │   ├── application/service/ExpensesService.java
│   │   │   └── infrastructure/rest/ExpensesController.java
│   │   ├── income/
│   │   │   ├── domain/model/Incomes.java
│   │   │   ├── domain/repository/IncomeRepository.java
│   │   │   ├── application/service/IncomeService.java
│   │   │   └── infrastructure/rest/IncomeController.java
│   │   └── KakeboApplication.java
│   └── src/main/resources/
│       ├── application.properties
│       ├── application-dev.properties ... H2 config
│       └── application-prod.properties .. PostgreSQL config
│
├── kakebo-front/
│   ├── README.md .................. Docs frontend
│   ├── AGENTS.md .................. Instrucciones para IA
│   ├── package.json
│   ├── .env.local ................. Variables de entorno
│   ├── vite.config.ts
│   ├── tsconfig.json
│   ├── src/
│   │   ├── app.css
│   │   ├── app.html
│   │   ├── lib/
│   │   │   ├── api.ts ........... Capa API tipada
│   │   │   ├── stores.ts ........ Stores reactivos
│   │   │   ├── i18n.ts
│   │   │   ├── components/
│   │   │   │   ├── common/ ...... UI base (Modal, Spinner, etc)
│   │   │   │   ├── forms/ ....... Formularios (Expense, Income)
│   │   │   │   ├── tables/ ...... Tablas (Expenses, Incomes)
│   │   │   │   └── layout/ ...... Componentes de layout
│   │   │   └── paraglide/ ....... i18n generado (no editar)
│   │   └── routes/
│   │       ├── +layout.svelte ... Layout principal
│   │       ├── +page.svelte .... Home
│   │       ├── +page.server.js .. Carga datos home
│   │       ├── expenses/ ........ Gestor de gastos
│   │       ├── incomes/ ......... Gestor de ingresos
│   │       ├── diario/ .......... Vista diaria (TODO)
│   │       ├── resumen/ ......... Análisis (TODO)
│   │       └── ayuda/ ........... Ayuda
│   └── .env.local ................ Configuración local
│
└── kakebo-admin/ .................. Proyecto aparte (admin dashboard)
```

---

## 🔌 Endpoints API

### Gastos
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/expenses` | Listar todos los gastos |
| `GET` | `/expenses/{id}` | Obtener un gasto |
| `POST` | `/expenses` | Crear gasto |
| `PUT` | `/expenses/{id}` | Actualizar gasto |
| `DELETE` | `/expenses/{id}` | Eliminar gasto |

### Ingresos
| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/incomes` | Listar todos los ingresos |
| `GET` | `/incomes/{id}` | Obtener un ingreso |
| `POST` | `/incomes` | Crear ingreso |
| `PUT` | `/incomes/{id}` | Actualizar ingreso |
| `DELETE` | `/incomes/{id}` | Eliminar ingreso |

**Documentación interactiva**: http://localhost:9090/swagger-ui.html

---

## 🛠️ Herramientas de Desarrollo

### Scripts Helper

Los scripts `dev.sh` (macOS/Linux) y `dev.bat` (Windows) simplifican el desarrollo local:

```bash
# macOS/Linux
./dev.sh start              # Inicia backend + frontend en nuevas ventanas
./dev.sh start-backend      # Solo backend
./dev.sh start-frontend     # Solo frontend
./dev.sh status             # Ver qué está corriendo
./dev.sh stop               # Detener todo
./dev.sh restart            # Reiniciar todo
./dev.sh help               # Mostrar ayuda

# Windows
dev.bat start               # Inicia backend + frontend en nuevas ventanas
dev.bat start-backend       # Solo backend
dev.bat start-frontend      # Solo frontend
dev.bat status              # Ver qué está corriendo
dev.bat stop                # Detener todo
dev.bat restart             # Reiniciar todo
dev.bat help                # Mostrar ayuda
```

### Verificación de Servicios

```bash
# Verificar que backend está corriendo
curl http://localhost:9090/expenses

# Verificar que frontend está corriendo
curl http://localhost:5173

# Ver logs en tiempo real
tail -f /tmp/kakebo-backend.log
tail -f /tmp/kakebo-frontend.log
```

---

### Backend

```bash
cd kakebo-backend

# Modo desarrollo
make start              # Inicia la app
make test               # Ejecuta tests
make lint               # Análisis estático (SonarQube)
make coverage           # Cobertura de tests
make help               # Ver todos los comandos

# O con Maven directamente
./mvnw spring-boot:run -Dspring.profiles.active=dev    # Dev
./mvnw spring-boot:run                                   # Prod (PostgreSQL)
./mvnw test                                              # Tests
./mvnw clean package                                     # Build JAR
```

### Frontend

```bash
cd kakebo-front

# Desarrollo
npm run dev             # Dev server con hot reload
npm run check           # Verificar tipos y compilación
npm run lint            # Eslint + Prettier
npm run format          # Formatea código

# Build
npm run build           # Crea distribución para producción
npm run preview         # Previsualiza el build

# Testing
npm run test:unit       # Vitest - tests unitarios
npm run test:e2e        # Playwright - tests end-to-end
npm run test            # Ambos
```

---

## ⚙️ Configuración

### Backend - Perfiles

**Desarrollo** (`application-dev.properties`):
- Base de datos: H2 in-memory
- No requiere Docker
- Puerto: 9090
- Datos se pierden al reiniciar

**Producción** (`application-prod.properties`):
- Base de datos: PostgreSQL
- Puerto: 9090
- Configurado para entornos reales

### Frontend - Variables de Entorno

Crear `.env.local` en `kakebo-front/`:

```env
# URL del backend
VITE_API_BASE_URL=http://localhost:9090

# (Opcional) Para producción
# VITE_API_BASE_URL=https://api.tudominio.com
```

---

## 🐛 Troubleshooting

**Guía completa de setup y solución de problemas**: Revisa [`SETUP.md`](./SETUP.md) para instrucciones detalladas.

### "El dev.sh no funciona en macOS"
```bash
# Hazlo ejecutable
chmod +x dev.sh

# O ejecútalo explícitamente
bash dev.sh start
```

### "Puerto 9090 ya está en uso"
```bash
# Encontrar el proceso
lsof -i :9090

# Matar el proceso
kill -9 <PID>

# O cambiar puerto en application-dev.properties
# server.port=9091
```

### "CORS error en frontend"
- Verificar que el backend está corriendo en `http://localhost:9090`
- El backend acepta peticiones desde `https://localhost:5173`
- En producción, actualizar CORS en `ExpensesController` y `IncomeController`

### "Cannot find module en frontend"
```bash
cd kakebo-front
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

### "Cambios en frontend no se actualizan"
- Verificar que `npm run dev` está corriendo
- Si persiste: `Ctrl+C` y `npm run dev` de nuevo
- Limpiar caché: `Ctrl+Shift+Delete` en el navegador

### "Base de datos se perdió al reiniciar"
- Es normal en H2 (modo desarrollo)
- Para datos persistentes, cambiar a PostgreSQL en `application-prod.properties`

### "Ver los logs detallados"
```bash
# Con los scripts helper
./dev.sh logs          # macOS/Linux
dev.bat status         # Windows

# O directamente
tail -f /tmp/kakebo-backend.log
tail -f /tmp/kakebo-frontend.log
```

---

## 📚 Documentación Adicional

### 🎯 Inicio Rápido
- **[`SETUP.md`](./SETUP.md)** - Guía de setup inicial con checklist, troubleshooting y comandos útiles
- **`dev.sh`** - Script helper para macOS/Linux (start, stop, status, logs)
- **`dev.bat`** - Script helper para Windows (start, stop, status, logs)

### 📖 Documentación Técnica
**Backend**:
- [`kakebo-backend/README.md`](./kakebo-backend/README.md) - Stack y arquitectura
- [`kakebo-backend/docs/00_INDEX.md`](./kakebo-backend/docs/00_INDEX.md) - Guía completa
- [`kakebo-backend/AGENTS.md`](./kakebo-backend/AGENTS.md) - Instrucciones para IA

**Frontend**:
- [`kakebo-front/README.md`](./kakebo-front/README.md) - Stack SvelteKit
- [`kakebo-front/AGENTS.md`](./kakebo-front/AGENTS.md) - Estructura de componentes e IA

---

## 🚢 Despliegue

### Docker (Próximamente)
```bash
# Build y run con Docker Compose
docker-compose up
```

### Producción Manual
```bash
# Backend
cd kakebo-backend
./mvnw clean package -DskipTests
java -jar target/kakebo-0.0.1-SNAPSHOT.jar

# Frontend
cd kakebo-front
npm run build
npm run preview
```

---

## 📝 Notas de Desarrollo

- **Git workflow**: Las ramas siguen el patrón `feature/*, bugfix/*, docs/*`
- **Commits**: Incluyen trailer `Co-authored-by: Copilot` (IA-assisted)
- **Código**: TypeScript + Svelte 5 (frontend), Java 21 + Spring Boot 3.x (backend)
- **Estilos**: TailwindCSS v4 (frontend)
- **i18n**: Español (es) + Inglés (en) con Paraglide

---

## 🤝 Contributing

1. Crea una rama desde `main`: `git checkout -b feature/tu-feature`
2. Implementa los cambios
3. Tests: `npm run test` (frontend) o `./mvnw test` (backend)
4. Commit con descripción clara
5. Push y abre un Pull Request

---

## 📄 Licencia

[Especificar licencia aquí]

---

## 💡 Próximas Mejoras

- [ ] Análisis y gráficos de gastos
- [ ] Categorización automática
- [ ] Exportar datos (PDF, Excel)
- [ ] Aplicación mobile (React Native)
- [ ] Sincronización multi-dispositivo
- [ ] Presupuestos y alertas

---

**¿Problemas?** Abre un issue o revisa la documentación en `docs/`
