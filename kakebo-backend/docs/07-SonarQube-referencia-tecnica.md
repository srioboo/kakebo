# 📚 SonarQube - Referencia Técnica Completa

**Última actualización:** 3 de Abril de 2026

## 🎯 Resumen Ejecutivo

Se ha implementado **SonarQube** como herramienta principal de análisis de calidad, reemplazando Checkstyle + PMD. Proporciona análisis consolidado, detección de vulnerabilidades, cobertura de código y dashboard interactivo.

---

## 🚀 Inicio Rápido (2 opciones)

### OPCIÓN 1: Análisis Rápido (5 minutos)

```bash
make lint
# Genera: target/site/jacoco/index.html
open target/site/jacoco/index.html
```

✅ **Ideal para:** Pre-commit checks, verificación rápida  
⏱️ **Tiempo:** 5 minutos  
🔧 **Requisitos:** Ninguno (no necesita Docker)

### OPCIÓN 2: SonarQube Completo (15 minutos)

```bash
# 1. Instalar SonarQube (primera vez)
./scripts/sonar-helper.sh install

# 2. Generar token
./scripts/sonar-helper.sh token

# 3. Ejecutar análisis
export SONAR_LOGIN=<tu-token>
make sonar

# 4. Ver dashboard
open http://localhost:9000
```

✅ **Ideal para:** CI/CD, análisis completo, seguimiento histórico  
⏱️ **Tiempo:** 15 minutos (primero), 3 min (siguiente)  
🔧 **Requisitos:** Docker

---

## 📊 Capacidades: SonarQube vs Checkstyle+PMD

| Característica | Checkstyle+PMD | SonarQube |
|---|---|---|
| Code Style | ✅ | ✅ |
| Bug Detection | ⚠️ PMD | ✅ Avanzado |
| Security Analysis | ❌ | ✅ 🔐 |
| Code Coverage | ❌ | ✅ JaCoCo |
| Duplication Detection | ❌ | ✅ |
| Dashboard Web | ❌ | ✅ Excelente |
| Historial/Tendencias | ❌ | ✅ |
| Community Edition | ✅ | ✅ |
| Configuración | 2 archivos | 1 archivo |

---

## 📁 Cambios Realizados

### Archivos Modificados

**pom.xml:**
- ✅ Agregadas propiedades SonarQube (sonar.projectKey, sources, tests, etc.)
- ✅ Plugin `sonar-maven-plugin` (v4.0.0.4121)
- ✅ Plugin `jacoco-maven-plugin` (v0.8.14)
- ❌ Eliminados: maven-checkstyle-plugin, maven-pmd-plugin

**Makefile:**
- ✅ Targets nuevos: `sonar`, `sonar-local`, `coverage`
- ❌ Eliminados: `checkstyle`, `pmd`

**scripts/manage.sh:**
- ✅ Funciones nuevas: `run_sonar()`, `run_sonar_local()`, `run_coverage()`
- ❌ Eliminadas: `run_checkstyle()`, `run_pmd()`

### Archivos Nuevos

**sonar-project.properties:**
```properties
sonar.projectKey=kakebo-backend
sonar.projectName=Kakebo Backend
sonar.language=java
sonar.sources=src/main
sonar.tests=src/test
sonar.exclusions=**/generated-sources/**
sonar.java.binaries=target/classes
sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
```

**scripts/sonar-helper.sh:**
- Gestión Docker de SonarQube
- Comandos: install, start, stop, status, logs, token, clean

---

## 🔧 Comandos Disponibles

### Make (Recomendado)

```bash
make lint              # Análisis + cobertura (SIN servidor)
make sonar             # Dashboard completo (CON servidor)
make sonar-local       # Análisis local (SIN servidor)
make coverage          # Solo cobertura JaCoCo
```

### Just / Scripts

```bash
just sonar             # Alternativa a make
./scripts/manage.sh sonar
./scripts/sonar-helper.sh install  # Instalar servidor Docker
```

### Maven Directo

```bash
# Con servidor
./mvnw clean verify sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<token>

# Sin servidor (local)
./mvnw clean verify -Dsonar.analysis.mode=publish
```

---

## 🏗️ Instalación del Servidor

### Con Docker (Recomendado)

```bash
# Opción 1: Automática (con helper script)
./scripts/sonar-helper.sh install

# Opción 2: Manual
docker run -d --name sonarqube \
  -p 9000:9000 \
  sonarqube:latest

# Esperar 30-60 segundos a iniciar
./scripts/sonar-helper.sh status
```

### Acceso

- URL: `http://localhost:9000`
- Usuario: `admin`
- Contraseña: `admin`

### Generar Token

```bash
# Automático
./scripts/sonar-helper.sh token

# Manual
1. http://localhost:9000
2. Avatar (arriba derecha) → My Account
3. Security → Generate Tokens
4. Nombre: "kakebo-token"
5. Copiar token → export SONAR_LOGIN=<token>
```

---

## 📊 Dashboard: Qué Monitoreear

### Métricas Principales

| Métrica | Qué es | Objetivo |
|---------|--------|----------|
| **Bugs** | Errores potenciales | 0 críticos |
| **Vulnerabilities** | Seguridad | 0 |
| **Code Smells** | Prácticas mejorables | < 10 |
| **Coverage** | % código con tests | ≥ 80% |
| **Duplication** | Código duplicado | < 5% |
| **Complexity** | Complejidad ciclomática | < 10/método |

### Vista del Dashboard

```
SonarQube Dashboard (http://localhost:9000)
├── Bugs: 3 (1 crítico)
├── Vulnerabilities: 0 ✅
├── Code Smells: 8
├── Coverage: 65%
├── Duplication: 2.3%
├── Complexity: Línea 45 - 12/método
└── Historial de cambios
```

---

## 🔄 Flujo de Trabajo Recomendado

### Desarrollo Local

```bash
# Antes de commit
make lint              # Análisis + cobertura
git add .
git commit -m "Feature: xxx"
git push
```

### CI/CD (GitHub Actions)

```yaml
name: Quality Analysis
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '21'
      - run: make lint
        env:
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
          SONAR_LOGIN: ${{ secrets.SONAR_LOGIN }}
```

### Pre-Push (Servidor Local)

```bash
# Opcional: análisis completo antes de push
./scripts/sonar-helper.sh install
export SONAR_LOGIN=<token>
make sonar
# Revisar en http://localhost:9000
git push
```

---

## 🛠️ Troubleshooting

### Error: "SonarQube no responde"

```bash
# Verificar estado
./scripts/sonar-helper.sh status

# Si no está corriendo
./scripts/sonar-helper.sh install

# Ver logs
./scripts/sonar-helper.sh logs
```

### Error: "Token inválido"

```bash
# Regenerar
./scripts/sonar-helper.sh token
# Copiar nuevo token y usar
export SONAR_LOGIN=<nuevo-token>
```

### Error: "Puerto 9000 en uso"

```bash
# Buscar proceso
lsof -i :9000

# Matar
kill -9 <PID>

# O usar puerto diferente
docker run -p 9001:9000 sonarqube:latest
```

### Error: "Docker no instalado"

```bash
# Usar análisis local (sin servidor)
make lint    # Funciona sin Docker
```

---

## 📈 Mejora Continua

### Mensualmente

1. Revisar dashboard en http://localhost:9000
2. Identificar tendencias de bugs/vulnerabilidades
3. Establecer objetivos de cobertura
4. Revisar código duplicado

### Cuando hay cambios importantes

1. Ejecutar `make lint` antes de commit
2. Revisar reportes en `target/site/jacoco/`
3. Agregar tests para nuevas funcionalidades
4. Reducir complejidad si es necesario

---

## 🔗 Archivos Relacionados

- **sonar-project.properties** - Configuración central
- **pom.xml** - Plugins y propiedades
- **Makefile/Justfile** - Comandos de ejecución
- **05-CalidadCodigo-sonarqube-cobertura.md** - Guía completa (docs/)

---

## 💡 Tips Profesionales

1. ✅ Ejecuta `make lint` antes de cada push
2. ✅ Monitorea tendencias, no solo números
3. ✅ Fija objetivos de cobertura en equipo (ej: ≥80%)
4. ✅ Revisa "Code Smells" regularmente
5. ✅ Vulnerabilidades = prioridad máxima
6. ✅ Complejidad alta = refactor necesario

---

**¡Listo!** SonarQube está configurado y listo para usar. Empieza con `make lint`.
