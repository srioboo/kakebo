# 🔧 Desarrollo & Entornos - Kakebo Backend

**Última actualización:** 3 de Abril de 2026

## Descripción General

El proyecto Kakebo soporta múltiples entornos de ejecución:
- **Desarrollo (dev)**: H2 en memoria, sin dependencias externas
- **Producción (prod)**: PostgreSQL persistente, Flyway migraciones
- **Testing**: H2, configuración aislada para tests

---

## 📋 Formas de Ejecución

### OPCIÓN 1: Maven Directo (Recomendado)

```bash
# Desarrollo
./mvnw spring-boot:run -Dspring.profiles.active=dev

# Producción
./mvnw spring-boot:run -Dspring.profiles.active=prod
```

**Ventajas:**
- ✅ Nativo de Spring Boot
- ✅ No necesita herramientas adicionales
- ✅ Funciona en cualquier OS

**Desventajas:**
- Comando largo

---

### OPCIÓN 2: Makefile ⭐ RECOMENDADO PARA EQUIPOS

```bash
# Ver todos los comandos disponibles
make help

# Desarrollo
make start
make test
make build

# Calidad de código
make lint
make coverage
make sonar

# Ayuda
make help
```

**Ventajas:**
- ✅ Estándar industrial
- ✅ Auto-documentado (`make help`)
- ✅ Compatible con CI/CD
- ✅ Escalable a nuevos entornos
- ✅ Funcion en Mac/Linux

**Desventajas:**
- Requiere `make` instalado (viene preinstalado en Mac/Linux)

---

### OPCIÓN 3: Justfile (Alternativa Moderna)

```bash
just start
just stop
just test
just build
just coverage
just lint
```

**Ventajas:**
- ✅ Más moderno que Make
- ✅ Sintaxis más clara
- ✅ Multiplataforma (Windows/Mac/Linux)

**Desventajas:**
- Requiere instalar `just` por separado

---

### OPCIÓN 4: Docker Compose (Producción)

```bash
# Inicia PostgreSQL
docker-compose up -d postgres

# En otra terminal, ejecuta la app
./mvnw spring-boot:run -Dspring.profiles.active=prod

# O directamente con Docker
docker-compose up  # Inicia todo
```

**Ventajas:**
- ✅ Aislamiento completo
- ✅ Entorno reproducible
- ✅ Perfecto para CI/CD y despliegue

**Desventajas:**
- Requiere Docker instalado

---

## 🌍 Configuración de Entornos

### application.properties (Común)

```properties
# Aplicación
spring.application.name=kakebo
server.port=9090

# Swagger/OpenAPI
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.api-docs.path=/v3/api-docs

# Logging por defecto
logging.level.root=ERROR
logging.level.org.springframework.web=INFO
logging.level.org.sirantar.kakebo=INFO

# Base de datos por defecto (PostgreSQL, usada si no se especifica perfil)
spring.datasource.url=jdbc:postgresql://localhost:52010/mydatabase
spring.datasource.username=myuser
spring.datasource.password=secret
spring.datasource.driver-class-name=org.postgresql.Driver

# Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Flyway
spring.flyway.enabled=false

# Docker Compose
spring.docker.compose.enabled=false
```

### application-dev.properties (Desarrollo)

```properties
# H2 Database (en memoria)
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# H2 Console para gestionar datos
spring.h2.console.enabled=true

# Auto-crear tablas en cada ejecución
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.show-sql=true

# Logging verboso para desarrollo
logging.level.org.springframework.web=DEBUG
logging.level.org.sirantar.kakebo=DEBUG
logging.level.org.hibernate.SQL=DEBUG

# Sin Flyway en desarrollo (DDL automático por Hibernate)
spring.flyway.enabled=false
```

**Acceso:**
- 🔗 API: http://localhost:9090
- 📚 Swagger: http://localhost:9090/swagger-ui.html
- 💾 H2 Console: http://localhost:9090/h2-console (usuario: `sa`, contraseña: vacío)

### application-prod.properties (Producción)

```properties
# PostgreSQL
spring.datasource.url=jdbc:postgresql://localhost:52010/mydatabase
spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.username=myuser
spring.datasource.password=secret

# Connection Pool (HikariCP)
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

# JPA: validar esquema, no crear
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=false

# Flyway: aplicar migraciones automáticamente
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
spring.flyway.baseline-on-migrate=true

# Logging: mínimo (solo warnings)
logging.level.root=WARN
logging.level.org.springframework=WARN
logging.level.org.sirantar.kakebo=INFO
logging.level.org.hibernate=WARN

# Performance
spring.jpa.properties.hibernate.jdbc.batch_size=20
spring.jpa.properties.hibernate.order_inserts=true
spring.jpa.properties.hibernate.order_updates=true

# Graceful shutdown
server.shutdown=graceful
spring.lifecycle.timeout-per-shutdown-phase=30s
```

---

## 🐳 Docker Compose

### Configuración (compose.yaml)

```yaml
services:
  postgres:
    image: 'postgres:latest'
    environment:
      - 'POSTGRES_DB=mydatabase'
      - 'POSTGRES_PASSWORD=secret'
      - 'POSTGRES_USER=myuser'
    ports:
      - '52010:5432'  # Mapea puerto 5432 (PostgreSQL) al 52010 local
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydatabase"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### Comandos

```bash
# Iniciar PostgreSQL
docker-compose up -d postgres

# Detener PostgreSQL
docker-compose down

# Ver logs
docker-compose logs -f postgres

# Ejecutar shell en PostgreSQL
docker-compose exec postgres psql -U myuser -d mydatabase
```

---

## 🔄 Flujo de Desarrollo Recomendado

### 1. Setup Inicial

```bash
# Clonar repositorio
git clone <repo>
cd kakebo-backend

# Verificar versión de Java
java -version  # Debe ser Java 21+

# Compilar proyecto
make build  # O: ./mvnw package
```

### 2. Desarrollo

```bash
# Terminal 1: Iniciar la aplicación
make start  # O: ./mvnw spring-boot:run -Dspring.profiles.active=dev

# Terminal 2: Ejecutar tests
make test

# Terminal 3: Ver cobertura
make coverage
```

### 3. Antes de Commit

```bash
# Ejecutar tests
make test

# Análisis de calidad
make lint

# Ver cobertura de código
make coverage
```

### 4. Despliegue a Producción

```bash
# Compilar
make build

# Iniciar PostgreSQL
docker-compose up -d postgres

# Ejecutar con perfil de producción
./mvnw spring-boot:run -Dspring.profiles.active=prod
```

---

## 🛠️ Problemas Comunes

### Error: "Port 9090 already in use"

```bash
# Encontrar qué está usando el puerto
lsof -i :9090

# Matar proceso
kill -9 <PID>

# O cambiar puerto en application.properties
server.port=9091
```

### Error: "Connection refused" (PostgreSQL)

```bash
# Asegúrate de que Docker está corriendo
docker-compose up -d postgres

# Verifica que está listo
docker-compose logs postgres

# Si está en prod, verifica credenciales
spring.datasource.url=jdbc:postgresql://localhost:52010/mydatabase
spring.datasource.username=myuser
spring.datasource.password=secret
```

### Error: "H2 Database not found"

```bash
# Verifica que H2 está en pom.xml:
# <dependency>
#     <groupId>com.h2database</groupId>
#     <artifactId>h2</artifactId>
#     <scope>runtime</scope>
# </dependency>

# Reconstruir
./mvnw clean install
```

### Error: "ClassNotFoundException: PostgreSQL Driver"

```bash
# PostgreSQL driver está en pom.xml
# Reconstruir Maven
./mvnw clean install

# O reinstalar dependencias
./mvnw dependency:resolve
```

### Java Version Mismatch

```bash
# Ver versión actual
java -version

# Debe ser Java 21+ (según pom.xml: <java.version>25</java.version>)
# Si es vieja, actualiza tu JDK
```

---

## 📚 Migraciones de Base de Datos (Flyway)

### Estructura

```
src/main/resources/db/migration/
├── V1__Initial_schema.sql
├── V2__Add_users_table.sql
├── V3__Add_indexes.sql
└── V4__Add_new_columns.sql
```

### Naming Convention

- `V{number}__{description}.sql` (ej: `V1__Initial_schema.sql`)
- Los números DEBEN ser secuenciales
- No pueden haber gaps (no puedes saltar de V1 a V3)

### Crear Nueva Migración

```sql
-- V2__Add_new_column.sql
ALTER TABLE expenses ADD COLUMN category VARCHAR(255);
```

### Ejecución

```bash
# Automática en producción
./mvnw spring-boot:run -Dspring.profiles.active=prod

# Manual (si es necesario)
./mvnw flyway:migrate -Dspring.profiles.active=prod
```

### Desactivar Flyway

```properties
# En application.properties
spring.flyway.enabled=false

# O en development
# Ya está desactivado en application-dev.properties
```

---

## 🔗 Referencias

- [Inicio Rápido](01-Inicio-inicio-rapido.md)
- [Arquitectura & Patrones](02-Arquitectura-hexagonal-patrones.md)
- [Testing & Errores](04-Testing-patrones-errores-comunes.md)
- [Calidad de Código](05-CalidadCodigo-sonarqube-cobertura.md)

