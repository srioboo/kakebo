# 📊 Calidad de Código - SonarQube & Cobertura - Kakebo Backend

**Última actualización:** 3 de Abril de 2026

## Resumen de Migración

Se completó la migración exitosa de herramientas de análisis de código:

```
ANTES                           DESPUÉS
├─ Checkstyle (estilos)        └─ SonarQube (plataforma unificada)
└─ PMD (bugs)
```

### ✅ Lo Que Se Ha Logrado

| Característica | Antes | Ahora |
|---|---|---|
| Análisis de seguridad | ❌ | ✅ Integrado |
| Detección de bugs | ⚠️ PMD solo | ✅ SonarQube avanzado |
| Cobertura de código | ❌ | ✅ JaCoCo |
| Dashboard web | ❌ | ✅ Interactivo |
| Historial de cambios | ❌ | ✅ Automático |

---

## 🚀 Opción 1: Análisis Rápido (Recomendado para Desarrollo)

Para verificar calidad rápidamente **sin servidor**:

```bash
cd /Users/salrio/Work/kakebo/kakebo-backend

# Ejecutar análisis local + cobertura
make lint
```

**Tiempo de ejecución:** 2-3 minutos  
**Resultado:** Reporte HTML en `target/site/jacoco/index.html`

### Qué genera:
- ✅ Análisis estático de código (SonarQube local)
- ✅ Reporte de cobertura JaCoCo
- ✅ HTML interactivo visualizable en navegador

### Ver reporte:
```bash
# Mac
open target/site/jacoco/index.html

# Linux
xdg-open target/site/jacoco/index.html

# Windows
start target/site/jacoco/index.html
```

---

## 🚀 Opción 2: SonarQube Completo con Dashboard (Recomendado para CI/CD)

Para análisis completo con dashboard interactivo:

### Paso 1: Instalar SonarQube en Docker (Una sola vez)

```bash
./scripts/sonar-helper.sh install
# Espera 30-60 segundos mientras se inicia

# Verifica que está corriendo
./scripts/sonar-helper.sh status
```

### Paso 2: Generar Token

```bash
# Se abrirá automáticamente tu navegador
./scripts/sonar-helper.sh token

# O manualmente:
# 1. Abre http://localhost:9000
# 2. Login: admin / admin
# 3. Avatar (arriba derecha) → "My Account"
# 4. "Security" → "Generate Tokens"
# 5. Nombre: "kakebo-token"
# 6. Copia el token
```

### Paso 3: Ejecutar Análisis

```bash
# Opción A: Variable de entorno
export SONAR_LOGIN=<tu-token-aqui>
make sonar

# Opción B: Directamente
SONAR_LOGIN=<tu-token-aqui> make sonar
```

### Paso 4: Ver Resultados

```bash
# Abre en navegador
open http://localhost:9000

# O desde el terminal
./scripts/sonar-helper.sh logs
```

### Dashboard Interactivo

En http://localhost:9000 verás:
- 🐛 **Bugs** detectados con severidad
- 🔐 **Vulnerabilidades de seguridad**
- 💡 **Code Smells** (prácticas mejorables)
- 📈 **Cobertura de código** por archivo
- 📊 **Historial de análisis** a lo largo del tiempo
- 🔄 **Tendencias** de calidad

---

## 📋 Comandos Disponibles

### Make (Recomendado)

```bash
make build              # Compilar
make test               # Ejecutar tests
make test-watch        # Tests en tiempo real
make lint               # ⭐ Análisis + cobertura (RÁPIDO)
make coverage           # Solo reporte de cobertura JaCoCo
make sonar              # Análisis completo con servidor
make sonar-local        # Análisis SonarQube sin servidor
make start              # Iniciar aplicación
make stop               # Detener aplicación
make help               # Ver todos los comandos
```

### Just (Alternativa moderna)

```bash
just build              # Compilar
just test               # Tests
just lint               # Análisis
just coverage           # Cobertura
just sonar              # Dashboard
just start              # Iniciar
```

### Scripts Directamente

```bash
# Análisis completo
./scripts/manage.sh lint
./scripts/manage.sh sonar
./scripts/manage.sh coverage

# SonarQube helper
./scripts/sonar-helper.sh install
./scripts/sonar-helper.sh start
./scripts/sonar-helper.sh stop
./scripts/sonar-helper.sh status
./scripts/sonar-helper.sh token
./scripts/sonar-helper.sh clean
```

---

## 🔧 Configuración

### sonar-project.properties

```properties
sonar.projectKey=kakebo-backend
sonar.projectName=Kakebo Backend
sonar.projectVersion=0.0.1-SNAPSHOT
sonar.language=java
sonar.sourceEncoding=UTF-8

# Rutas de análisis
sonar.sources=src/main
sonar.tests=src/test
sonar.exclusions=**/generated-sources/**
sonar.java.binaries=target/classes
sonar.java.libraries=target/classes

# JaCoCo (cobertura)
sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
sonar.java.coveragePlugin=jacoco
```

### Configuración en pom.xml

```xml
<!-- SonarQube Plugin -->
<plugin>
    <groupId>org.sonarsource.scanner.maven</groupId>
    <artifactId>sonar-maven-plugin</artifactId>
    <version>4.0.0.4121</version>
</plugin>

<!-- JaCoCo para Cobertura -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.14</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

---

## 📊 Métricas que Monitorea SonarQube

### 🐛 Bugs
- Lógica incorrecta
- NullPointerException potenciales
- Comparaciones incorrectcadas
- Variables no utilizadas

### 🔐 Vulnerabilidades
- Inyección SQL
- Hardcoded credentials
- Inseguridad en desserialización
- CORS misconfigured

### 💡 Code Smells (Prácticas Mejorables)
- Métodos muy largos
- Complejidad ciclomática alta
- Duplicación de código
- Nombres poco claros

### 📈 Cobertura de Código
- Porcentaje de código cubierto por tests
- Líneas ejecutadas vs totales
- Desglose por archivo/paquete

---

## 🔄 Flujo CI/CD Recomendado

### Pre-Commit (Desarrollo Local)

```bash
# Antes de hacer commit
make lint              # Análisis + cobertura
make test              # Ejecutar tests

# Si todo pasa, puedes hacer commit
git commit -m "Feature: ..."
git push
```

### GitHub Actions (CI/CD Automático)

```yaml
# .github/workflows/sonarqube.yml
name: SonarQube Analysis
on: [push, pull_request]

jobs:
  sonarqube:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up JDK
        uses: actions/setup-java@v3
        with:
          java-version: '25'
      
      - name: Build & Analyze
        run: make lint
        env:
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
          SONAR_LOGIN: ${{ secrets.SONAR_LOGIN }}
```

---

## 🎯 Objetivos de Calidad Recomendados

| Métrica | Objetivo | Actual |
|---|---|---|
| Cobertura de código | ≥ 80% | Por definir |
| Bugs detectados | 0 (críticos) | Por definir |
| Vulnerabilidades | 0 | Por definir |
| Code Smells | < 10 | Por definir |
| Complejidad ciclomática | < 10/método | Por definir |

---

## 🚨 Problemas Comunes

### Error: "SonarQube no está corriendo"

```bash
# Verifica si está arriba
./scripts/sonar-helper.sh status

# Si no, inicia:
./scripts/sonar-helper.sh install
```

### Error: "Token inválido"

```bash
# Regenera token:
./scripts/sonar-helper.sh token

# O manualmente en http://localhost:9000
# Settings → Security → Tokens → New Token
```

### Error: "Puerto 9000 en uso"

```bash
# Busca qué está usando
lsof -i :9000

# Mata el proceso
kill -9 <PID>

# O cambia puerto en scripts/sonar-helper.sh
```

### Error: "Docker no disponible"

```bash
# Verifica Docker
docker --version

# Si no está instalado, usa make lint (sin servidor)
make lint
```

---

## 📚 Archivos Generados por SonarQube

```
target/
├── site/
│   └── jacoco/
│       ├── index.html           ← Abre esto en navegador
│       ├── jacoco.xml           ← Datos brutos (XML)
│       └── *.html               ← Reportes por paquete
└── classes/
    └── [bytecode compilado]
```

---

## 🔗 Referencias

- [Inicio Rápido](01-Inicio-inicio-rapido.md)
- [Desarrollo & Entornos](03-Desarrollo-entornos-configuracion.md)
- [Testing & Errores](04-Testing-patrones-errores-comunes.md)
- [Documentación Oficial SonarQube](https://docs.sonarqube.org/)
- [JaCoCo Documentation](https://www.jacoco.org/)

---

## 💡 Tips Profesionales

1. **Ejecuta `make lint` antes de push** para evitar sorpresas en CI/CD
2. **Monitorea tendencias** en el dashboard, no solo números absolutos
3. **Fija objetivos de cobertura** (ej: ≥80%) en tu equipo
4. **Revisa "Code Smells"** regularmente, podrían indicar refactoring necesario
5. **Las vulnerabilidades** siempre deben tener severidad 0 en producción

---

**¡Listo!** Ahora tienes un sistema robusto de calidad de código en lugar de herramientas fragmentadas (Checkstyle + PMD).

