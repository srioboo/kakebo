# Kakebo Backend

> Repository docs: `../docs/README.md` (repository wiki) — see `../docs/api-contract.md` for the canonical API contract.

Kakebo personal finances project backend - Spring Boot 4.x con arquitectura hexagonal.

**🚀 [Ir a Documentación →](docs/00_INDEX.md)**

## Inicio Rápido

```bash
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

> Si arrancas desde la raíz con `dev.sh start` o `dev.bat start`, el helper comprobará Docker/Podman y te pedirá elegir un runtime si no hay uno activo. `dev.sh` también activa Java 21.0.2-graalce con SDKMAN antes de iniciar el backend.

Luego abre: http://localhost:9090/swagger-ui.html

## Comandos Rápidos

```bash
make help               # Ver todos los comandos
make start              # Iniciar aplicación
make test               # Ejecutar tests
make lint               # Análisis de código (SonarQube)
make coverage           # Cobertura de tests
```

---

## 📚 Documentación

Toda la documentación está organizada en la carpeta [`docs/`](docs/00_INDEX.md):

| Tema | Descripción |
|------|-------------|
| [🚀 Inicio Rápido](docs/01-Inicio-inicio-rapido.md) | Ejecuta la app en 30 segundos |
| [🏗️ Arquitectura](docs/02-Arquitectura-hexagonal-patrones.md) | Estructura hexagonal y patrones |
| [🔧 Desarrollo](docs/03-Desarrollo-entornos-configuracion.md) | Entornos, configuración, Docker |
| [🧪 Testing](docs/04-Testing-patrones-errores-comunes.md) | Tests, errores comunes |
| [📊 Calidad](docs/05-CalidadCodigo-sonarqube-cobertura.md) | SonarQube, cobertura |
| [🎨 Referencia](docs/06-Referencia-diagramas-visuales.md) | Diagramas visuales |

**[→ Ver Índice Completo](docs/00_INDEX.md)**

---

## Para Agentes IA

Ver [AGENTS.md](AGENTS.md) para instrucciones especializadas para agentes de IA que trabajan en este proyecto.

---

## Unified Script: `manage.sh`, Make, and Just

The `manage.sh` script simplifies the management of the Spring Boot application. It supports the following commands:

- **Start the application**:
  ```bash
  ./scripts/manage.sh start
  ```

- **Stop the application**:
  ```bash
  ./scripts/manage.sh stop
  ```

- **Build the project**:
  ```bash
  ./scripts/manage.sh build
  ```

- **Run tests**:
  ```bash
  ./scripts/manage.sh test
  ```

- **Show help**:
  ```bash
  ./scripts/manage.sh help
  ```

### Using Make

You can also manage the application using `make` commands:

- **Start the application**:
  ```bash
  make start
  ```

- **Stop the application**:
  ```bash
  make stop
  ```

- **Build the project**:
  ```bash
  make build
  ```

- **Run tests**:
  ```bash
  make test
  ```

### Using Just

Alternatively, you can use `just` for the same tasks:

- **Start the application**:
  ```bash
  just start
  ```

- **Stop the application**:
  ```bash
  just stop
  ```

- **Build the project**:
  ```bash
  just build
  ```

- **Run tests**:
  ```bash
  just test
  ```

- **Update Maven Wrapper**:

  ```bash
  ./mvnw -N io.takari:maven:wrapper -Dmaven=<version>
  ```

- **Run the project**:

  ```bash
  # For development (uses H2 in-memory database):
  ./mvnw spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
  
  # Or with Maven direct execution:
  ./mvnw clean spring-boot:run -Dspring.profiles.active=dev
  
  # For production (uses PostgreSQL):
  ./mvnw spring-boot:run
  ```

- **Run the project without tests**:

  ```bash
  ./mvnw spring-boot:run -Dspring-boot.run.skipTests=true
  ```

- **Run tests**:

  ```bash
  ./mvnw test
  ```

- **Build the project**:

  ```bash
  ./mvnw package
  ```

## Architecture

Hexagonal architecture

```shell
src
├── main
│  ├── java
│  │  └── org
│  │     └── sirantar
│  │        └── kakebo
│  │           └── KakeboApplication.java
│  └── resources
│     ├── application.properties
│     ├── db
│     │  └── migration
│     ├── static
│     └── templates
├── Main.java
└── test
└── java
└── org
└── sirantar
└── kakebo
├── gastos
├── ingresos
└── KakeboApplicationTests.java
```

## Troubleshooting

### Recent Changes (2026-03-03)

The following improvements have been made to the project:

1. **Controllers Completed**: Both `ExpensesController` and `IncomeController` now have all CRUD endpoints implemented:
   - GET /expenses and /incomes - List all items
   - GET /expenses/{id} and /incomes/{id} - Get single item
   - POST /expenses and /incomes - Create new item
   - PUT /expenses/{id} and /incomes/{id} - Update existing item
   - DELETE /expenses/{id} and /incomes/{id} - Delete item

2. **Development Database**: Created `application-dev.properties` profile with:
   - H2 in-memory database for easy development (no PostgreSQL required)
   - Auto-created tables via Hibernate (ddl-auto=create-drop)
   - H2 Console available at http://localhost:9090/h2-console

3. **Configuration Changes**:
   - Docker Compose disabled in default configuration
   - Flyway disabled for development (can be re-enabled in production)
   - Logging level changed to ERROR for cleaner output
   - Added H2 database dependency to pom.xml

### API Endpoints

#### Expenses Endpoints
- `GET /expenses` - Get all expenses
- `GET /expenses/{id}` - Get expense by ID
- `POST /expenses` - Create new expense
- `PUT /expenses/{id}` - Update expense
- `DELETE /expenses/{id}` - Delete expense

#### Incomes Endpoints
- `GET /incomes` - Get all incomes
- `GET /incomes/{id}` - Get income by ID
- `POST /incomes` - Create new income
- `PUT /incomes/{id}` - Update income
- `DELETE /incomes/{id}` - Delete income

### Swagger Documentation

API documentation available at: `http://localhost:9090/swagger-ui.html`

### Database Configuration

#### Development (H2 In-Memory)
To run in development mode with H2 database:
```bash
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

#### Production (PostgreSQL)
To use PostgreSQL, ensure database is running on port 52010:
```bash
./mvnw spring-boot:run
```

### Troubleshooting

1. If Docker gives an error, test that Docker is working:

    - For Podman users, start the Podman service on Linux:

      ```bash
      systemctl --user start podman
      ```

    - To use Podman without the daemon:

      ```bash
      # init virtual machine
      podman machine init
      # start virtual machine
      podman machine start
      ```

    - Also, ensure that port 8080 is not in use.
2. If there are complaints about the Gradle version with JDK 22, note that Gradle does not work with JDK 22. Use JDK 21 instead.

## Gradle

I changed from Gradle to Maven because it is easier for me to maintain. However, I will conserve the Gradle files here for reference.

### Gradle Commands

Here are some useful Gradle commands for building, testing, and running the project:

- **Update Gradle Wrapper**:

  ```bash
  ./gradlew wrapper --gradle-version <version>
  ```

- **Run the project**:

  ```bash
  ./gradlew bootRun
  ```

- **Run the project without tests**:

  ```bash
  ./gradlew bootRun -x test
  ```

- **Run tests**:

  ```bash
  ./gradlew test
  ```

- **Build the project**:

  ```bash
  ./gradlew build
  ```

### Gradle Files

build.gradle.kts

```kotlin
plugins {
    id("java")
    id("org.springframework.boot") version "3.3.0"
    id("io.spring.dependency-management") version "1.1.5"
}

group = "org.sirantar.kakebo"
version = "0.0.1-SNAPSHOT"

// java {
    // toolchain {
        // languageVersion = JavaLanguageVersion.of(21)
    // }
// }

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-web")
    developmentOnly("org.springframework.boot:spring-boot-docker-compose")
    implementation("org.flywaydb:flyway-database-postgresql:10.20.1")  // Dependencia de Flyway
    runtimeOnly("org.postgresql:postgresql")
    runtimeOnly("org.springframework.boot:spring-boot-devtools")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    // https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-starter-webmvc-ui - swagger
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.1.0")
}

tasks.test {
    useJUnitPlatform()
    testLogging {
        events("passed", "skipped", "failed")
    }
}
```

settings.gradle.kts

```kotlin
rootProject.name = "kakebo-backend"
```
