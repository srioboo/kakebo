# 🎨 Referencia Visual - Diagramas & Arquitectura

**Última actualización:** 3 de Abril de 2026

## 1. Flujo de Desarrollo Actual vs Recomendado

### ANTES (Implementación Original)

```
┌─────────────────────────────────────────┐
│     Developer Local                     │
└──────────────┬──────────────────────────┘
               │
        ┌──────┴──────┐
        │             │
   ./run-dev.sh   ./run-prod.sh
        │             │
    ✅ OK         ⚠️ FAIL (sin DB)
        │             │
    H2 DB      Espera manual
               de PostgreSQL
```

### DESPUÉS (Recomendado)

```
┌─────────────────────────────────────────┐
│     Developer Local                     │
└──────────────┬──────────────────────────┘
               │
         make help
               │
    ┌──────────┼──────────┐
    │          │          │
make dev   make prod  make test
    │          │          │
    ✅ H2     ✅ PG      ✅ TEST
   Auto    (Auto-Docker) (Pass)
```

---

## 2. Arquitectura de Perfiles

```
application.properties (Base)
    │
    ├─── [DEV] ──────────→ application-dev.properties
    │                        H2 in-memory
    │                        DDL: create-drop
    │                        Logging: DEBUG
    │
    ├─── [PROD] ─────────→ application-prod.properties
    │                        PostgreSQL
    │                        DDL: validate
    │                        Logging: WARN
    │
    ├─── [TEST] ─────────→ application-test.properties
    │                        H2 in-memory
    │                        DDL: create-drop
    │                        Mocking
    │
    └─── [STAGING] ──────→ application-staging.properties
                            PostgreSQL
                            DDL: validate
                            Logging: INFO
```

---

## 3. Ciclo de Vida: Desarrollo a Producción

```
┌──────────────────────────────────────────────────────┐
│                 DESARROLLO LOCAL                     │
│  make dev → H2 in-memory → Swagger → Tests Manuales  │
└────────────────┬─────────────────────────────────────┘
                 │
                 │ git push
                 ↓
┌──────────────────────────────────────────────────────┐
│              CI/CD PIPELINE (GitHub)                 │
│                                                      │
│  1️⃣  Checkout                                        │
│  2️⃣  make test     → JUnit + Integration Tests      │
│  3️⃣  make build    → JAR artifact                   │
│  4️⃣  SonarQube     → Code quality                   │
│  5️⃣  Docker build  → Image pushed                   │
└────────────────┬─────────────────────────────────────┘
                 │
                 │ Tag/Release
                 ↓
┌──────────────────────────────────────────────────────┐
│           DEPLOY A STAGING                           │
│  docker compose -f docker-compose.staging.yml up     │
│  → PostgreSQL automático                             │
│  → Health checks                                     │
│  → Smoke tests                                       │
└────────────────┬─────────────────────────────────────┘
                 │
                 │ Manual approval
                 ↓
┌──────────────────────────────────────────────────────┐
│           DEPLOY A PRODUCCIÓN                        │
│  docker compose -f docker-compose.prod.yml up        │
│  → PostgreSQL con persistencia                       │
│  → Monitoring activo                                 │
│  → Auto-restart enabled                             │
│  → Backups configurados                             │
└──────────────────────────────────────────────────────┘
```

---

## 4. Opciones de Lanzamiento Disponibles

```
                    KAKEBO BACKEND
                          │
                ┌─────────┼─────────┐
                │         │         │
          SCRIPTS      MAKEFILE    DOCKER
            │             │          │
      ┌─────┴─────┐   ┌───┴──┐   ┌──┴──┐
      │           │   │      │   │     │
    DEV         PROD  make   make docker
   script      script  dev   prod compose
      │           │    │      │   │
   H2 DB      PG(?)  H2 DB  PG  PG+App
      │           │    │      │   │
    ✅         ⚠️✅ ✅✅ ✅  ✅✅✅
    Fast       Manual Auto  Auto  Full
```

---

## 5. Decisión: ¿Cuál Usar?

```
                START HERE
                    │
         "¿Nuevo en el proyecto?"
                    │
              ┌─────┴─────┐
              │ SÍ        │ NO
              ↓           ↓
           "make help"  "¿Equipo?"
              │           │
              │      ┌────┴────┐
              │      │ SÍ      │ NO
              │      ↓         ↓
              │    "make"   "make dev"
              │      │         │
              └──────┴─────────┘
                     │
              "¿Necesitas
               producción?"
                     │
                ┌────┴────┐
                │ SÍ      │ NO
                ↓         ↓
             "make   "Keeps
              prod"    dev"
                │
              "¿Docker?"
                │
           ┌────┴────┐
           │ SÍ      │ NO
           ↓         ↓
        "docker   "make
         compose   prod"
          up"
```

---

## 6. Stack de Tecnologías por Entorno

### DESARROLLO

```
┌─────────────────────────┐
│   DEVELOPMENT STACK     │
├─────────────────────────┤
│ JDK: 25                 │
│ Spring Boot: 4.0.1      │
│ Database: H2 (memory)   │
│ ORM: Hibernate          │
│ Migrations: Flyway (OFF)│
│ Logging: DEBUG          │
│ API Docs: Swagger UI    │
│ Testing: JUnit 5        │
└─────────────────────────┘
```

### PRODUCCIÓN

```
┌─────────────────────────┐
│  PRODUCTION STACK       │
├─────────────────────────┤
│ JDK: 25                 │
│ Spring Boot: 4.0.1      │
│ Database: PostgreSQL    │
│ ORM: Hibernate          │
│ Migrations: Flyway (ON) │
│ Logging: WARN/INFO      │
│ API Docs: Swagger UI    │
│ Monitoring: Actuator    │
│ Container: Docker       │
└─────────────────────────┘
```

---

## 7. Matriz de Compatibilidad

```
╔════════════════════════════════════════════════════╗
║           COMPATIBILITY MATRIX                     ║
╠════════════════════════════════════════════════════╣
║ OS/Method    │ Scripts│ Makefile│ Maven │ Docker ║
╠════════════════════════════════════════════════════╣
║ macOS        │   ✅   │   ✅    │  ✅   │   ✅   ║
║ Linux        │   ✅   │   ✅    │  ✅   │   ✅   ║
║ Windows      │   ❌   │   ⚠️    │  ✅   │   ✅   ║
║ CI/CD        │   ⚠️   │   ✅    │  ⚠️   │   ✅   ║
║ Containers   │   ❌   │   ⚠️    │  ⚠️   │   ✅   ║
║ Kubernetes   │   ❌   │   ❌    │  ❌   │   ⚠️   ║
╚════════════════════════════════════════════════════╝
```

---

## 8. Timeline: De Scripts a Enterprise

```
        Ahora            Semana 1         Semana 2       Mes 2
        ┌─────────────────┬──────────────┬──────────────┬─────────┐
        │                 │              │              │         │
    Scripts ─────→  Makefile  ────→  GitHub Actions  ─→  Docker  ─→  Kube
    Basic         Professional        CI/CD            Enterprise
        │                 │              │              │
        │                 │              │              │
    ⭐⭐⭐         ⭐⭐⭐⭐    ⭐⭐⭐⭐⭐       ⭐⭐⭐⭐⭐
   Funciona       Profesional      Automático        Escalable
```

---

## 9. Flujo de un Desarrollador Típico

### DÍA 1: Primer Push

```
→ git clone kakebo
→ "¿Cómo lo ejecuto?" 
→ make help
  ✅ Ve todas las opciones
→ make dev
  ✅ Funciona (H2)
→ Abre http://localhost:9090/swagger-ui.html
→ ✅ Ve la API
→ Código → Commit → Push
```

### DÍA 7: Revisión en Staging

```
→ CI/CD automático ejecutó los tests ✅
→ Build pasó ✅
→ Imagen Docker construida ✅
→ make prod (localmente)
→ ✅ Conecta a PostgreSQL
→ Prueba con datos reales
→ Aprobación para producción
```

---

## 10. Costo-Beneficio Visual

```
ESFUERZO DE IMPLEMENTACIÓN
    │
    │         Docker
    │         ▲
    │         │  ╱╲
    │         │ ╱  ╲
    │         │╱    ╲ Makefile
    │        │╱      ╲╱╲
  BAJO │      │Scripts ╱ Maven
    │  │      │╱       ╱
    │  └─────────────────────→ BENEFICIO A LARGO PLAZO
       BAJO              ALTO


Scripts:    Bajo costo, bajo beneficio
Makefile:   Bajo costo, alto beneficio ⭐ IDEAL
Maven:      Medio costo, medio beneficio
Docker:     Alto costo, muy alto beneficio
```

---

## 11. Recomendación Visual Final

```
┌────────────────────────────────────────────────────┐
│          ¿DÓNDE ESTÁS?                             │
├────────────────────────────────────────────────────┤
│                                                    │
│  INICIO               CRECIMIENTO        ESCALA   │
│  (1-2 devs)          (3-10 devs)        (10+)    │
│     │                    │                 │      │
│     ↓                    ↓                 ↓      │
│  make dev        make + GitHub      Docker +     │
│    +H2           Actions + Docker   Kubernetes   │
│                                                    │
│  ← IMPLEMENTADO AHORA → PLAN PARA DESPUÉS →      │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 12. Cambios Realizados - Resumen Visual

```
┌─────────────────────────────────────────────────────┐
│           BEFORE vs AFTER                           │
├──────────────────────┬──────────────────────────────┤
│ ANTES                │ DESPUÉS                      │
├──────────────────────┼──────────────────────────────┤
│                      │                              │
│ run-dev.sh ────────→ run-dev.sh mejorado           │
│ (básico)             (validaciones + colores)       │
│                      │                              │
│ run-prod.sh ────────→ run-prod.sh mejorado         │
│ (sin DB auto)        (Docker Compose automático)   │
│                      │                              │
│ NADA ──────────────→ Makefile (10 comandos)       │
│                      │                              │
│ NADA ──────────────→ application-prod.properties   │
│                      │                              │
│ NADA ──────────────→ 5 archivos de docs            │
│                      │                              │
└──────────────────────┴──────────────────────────────┘

TOTAL: 9 archivos nuevos/mejorados
TIEMPO AHORRO FUTURO: Horas/Semanas
```

---

## 🔗 Referencias

- [Inicio Rápido](01-Inicio-inicio-rapido.md)
- [Arquitectura & Patrones](02-Arquitectura-hexagonal-patrones.md)
- [Desarrollo & Entornos](03-Desarrollo-entornos-configuracion.md)
- [Testing & Errores](04-Testing-patrones-errores-comunes.md)
- [Calidad de Código](05-CalidadCodigo-sonarqube-cobertura.md)

---

Este documento es tu mapa visual para entender toda la arquitectura del proyecto. 🗺️

