# AGENTS.md - Kakebo Backend AI Agent Guide

## Project Overview
Kakebo is a Spring Boot 4.x personal finance management application using **hexagonal (ports & adapters) architecture**. Two main domains: Expenses and Incomes with REST APIs, PostgreSQL (production) and H2 (development).

---

## Architecture & Domains

### Hexagonal Architecture Pattern
```
domain/model/          → JPA Entities (Expenses, Incomes)
domain/repository/     → CrudRepository interfaces
application/service/   → Business logic, @Service
infrastructure/rest/   → Controllers, REST endpoints
```

**Key Convention**: Package structure mirrors domain separation: `expenses/` and `income/` are isolated domains.

### Domain Classes
- **Expenses**: `id`, `amount` (BigDecimal), `expenseName`, `expenseDate` (LocalDateTime)
- **Incomes**: `id`, `amount` (BigDecimal), `incomeName`, `expenseDate` (LocalDateTime - reuse for both)
- **Both use Lombok**: Requires annotation processing in Maven compiler

### Critical Implementation Detail
Both `Expenses` and `Incomes` **must implement `equals()` and `hashCode()`** for tests to work (see `docs/08_SOLUCION_EQUALS_HASHCODE.md`). Without these, object comparisons in tests fail even with identical values.

---

## Build, Test & Development Commands

### Unified Script System
All commands are wrapped in `scripts/manage.sh`, aliased by `Makefile` and `Justfile`:

```bash
make build              # ./mvnw package
make test               # ./mvnw test
make start              # ./mvnw spring-boot:run
make stop               # pkill -f 'spring-boot:run'
make lint               # SonarQube local + coverage report
make coverage           # JaCoCo report (target/site/jacoco/index.html)
make sonar              # SonarQube with server (requires server running)
```

### Development Profile
```bash
./mvnw spring-boot:run -Dspring.profiles.active=dev
# Uses H2 in-memory database, creates tables automatically
# H2 Console: http://localhost:9090/h2-console
# API Docs: http://localhost:9090/swagger-ui.html
```

### Production Profile  
```bash
./mvnw spring-boot:run -Dspring.profiles.active=prod
# Uses PostgreSQL (docker-compose.yaml: localhost:52010)
# Flyway migrations enabled
# Requires running: docker-compose up -d postgres
```

---

## Database Configuration Patterns

### Profile-Specific Properties
- **application.properties** (default): PostgreSQL config (not used in dev)
- **application-dev.properties**: H2 config, `ddl-auto=create-drop`, Flyway disabled
- **application-prod.properties**: PostgreSQL config, `ddl-auto=validate`, Flyway enabled

### Key Setting: `spring.jpa.hibernate.ddl-auto`
- Development: `update` → creates/updates tables automatically
- Production: `validate` → only validates schema exists (uses Flyway migrations)
- Test: `create-drop` → fresh schema per test session

### Flyway Migrations
- Located: `src/main/resources/db/migration/`
- Naming: `V{number}__{description}.sql` (e.g., `V1__Initial_schema.sql`)
- Only runs in production profile (`spring.profiles.active=prod`)
- Development uses Hibernate auto-DDL instead

---

## REST API Endpoints & Controllers

### Expenses API
```
GET    /expenses           → ExpensesService.getExpenses() → all
GET    /expenses/{id}      → ExpensesService.getExpenseById(id)
POST   /expenses           → ExpensesService.createExpense(object)
PUT    /expenses/{id}      → ExpensesService.updateExpense(id, object)
DELETE /expenses/{id}      → ExpensesService.deleteExpense(id)
```

### Incomes API
```
GET    /incomes            → IncomeService.getIncomes() → all
GET    /incomes/{id}       → IncomeService.getIncome(id)
POST   /incomes            → IncomeService.createIncome(object)
PUT    /incomes/{id}       → IncomeService.updateIncome(id, object)
DELETE /incomes/{id}       → IncomeService.deleteIncome(id)
```

### Controller Patterns
- **ExpensesController**: `@CrossOrigin(origins = "https://localhost:5173")` for frontend CORS
- Both use constructor injection: `@Autowired public Controller(Service service)`
- Swagger annotations: `@Operation(summary="...", description="...")` on each method
- **TODO**: DTOs not yet implemented (currently returning entity objects directly)

---

## Testing Framework & Patterns

### Test Classes
- **IncomeRestTest.java**: REST integration tests using `RestTemplate` (not WebTestClient)
- **ExpenseJsonTest.java**, **IncomeJsonTest.java**: JSON serialization tests
- **KakeboApplicationTests.java**: Context load test

### Test Setup Pattern
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IncomeRestTest {
    @LocalServerPort private int port;
    private String baseUrl;
    private RestTemplate restTemplate = new RestTemplate();  // NOT @Autowired
    
    @BeforeEach
    void setUp() {
        baseUrl = "http://localhost:" + port;
    }
}
```

**Important**: Spring Boot 4.x removed `TestRestTemplate` bean registration. Use `RestTemplate` instantiated locally instead.

### Test Assertion Pattern
```java
DocumentContext doc = JsonPath.parse(response.getBody());
Number id = doc.read("$.id");
assertThat(id).isEqualTo(1);  // Uses AssertJ
```

### Coverage Tool
- **JaCoCo** configured in pom.xml
- Report generated: `target/site/jacoco/index.html`
- Command: `make coverage`

---

## Code Quality & Linting

### SonarQube Setup
- **Local analysis** (no server): `make lint` (also generates coverage)
- **Server analysis**: `make sonar` (requires running SonarQube server)
- Config file: `sonar-project.properties`
- Maven plugin version: 4.0.0.4121

### SonarQube Properties
```properties
sonar.projectKey=kakebo-backend
sonar.sources=src/main
sonar.tests=src/test
sonar.exclusions=**/generated-sources/**
sonar.java.binaries=target/classes
```

### Previous Linting (Deprecated)
- **Checkstyle** & **PMD** were used but replaced with SonarQube
- Configuration files may exist but are no longer active
- See `docs-ci-cd/` for migration details

---

## Project-Specific Conventions

### Lombok Annotation Processing
- Requires `<annotationProcessorPaths>` in maven-compiler-plugin
- Classes should use `@Data` (generates getters, setters, equals, hashCode, toString)
- **Current state**: Most classes lack proper Lombok annotations despite having getters/setters manually

### Dependency Injection Convention
- Constructor injection preferred: `private final Service service;` with `@Autowired` constructor
- Field injection also used but less preferred: `@Autowired private Service service;`

### Optional Handling Pattern
```java
Optional<Entity> found = repository.findById(id);
return found.orElse(new Entity());  // Returns empty object if not found
// Better: return found.orElseThrow() for true Optional behavior
```

### Service Layer Pattern
- Services handle all business logic
- Controllers immediately delegate to services
- Repositories use Spring Data CRUD queries only (no custom queries yet)

### Response Patterns
- Most endpoints return entity directly (TODO: need DTO conversion)
- Some use `ResponseEntity.ok()` for explicit status codes
- POST currently returns 200 OK but should return 201 Created (see test TODO in IncomeRestTest.java)

---

## Docker & Deployment

### Docker Compose Configuration
```yaml
# compose.yaml - PostgreSQL for production
services:
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_DB: mydatabase
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: secret
    ports:
      - '52010:5432'
```

### Docker Compose in App
- **Disabled in default config**: `spring.docker.compose.enabled=false`
- Must manually run: `docker-compose up -d postgres` or `docker-compose up`
- Connection string in `application-prod.properties`: `jdbc:postgresql://localhost:52010/mydatabase`

### Port Configuration
- **Server port**: 9090 (configured in application.properties)
- **PostgreSQL**: 52010 (mapped from Docker container 5432)

---

## Documentation Map

### Core Understanding
- `docs/01_QUICK_START.md` → 30-second dev setup
- `docs/02_RESUMEN_EJECUTIVO.md` → Problems solved and current state
- `docs/03_CAMBIOS_REALIZADOS.md` → Detailed change log

### Architecture & Patterns
- `docs/10_MEJORES_PRACTICAS_SPRING.md` → Spring best practices applied
- `docs/08_SOLUCION_EQUALS_HASHCODE.md` → Entity comparison patterns
- `docs/07_SOLUCION_WEBTESTCLIENT_ERROR.md` → Testing patterns (RestTemplate vs WebTestClient)

### CI/CD & Quality
- `docs-ci-cd/11_GUIA_RAPIDA_LINTING.md` → Quick linting guide
- `docs-ci-cd/23_IMPLEMENTACION_SONARQUBE.md` → SonarQube implementation details

---

## Common Agent Tasks

### Adding a New Endpoint
1. Create method in `Service` class (domain logic)
2. Add `@RestMapping` method in `Controller` class with Swagger annotation
3. Ensure `@CrossOrigin` is present if frontend needs it
4. Add test in corresponding `RestTest.java` using RestTemplate pattern
5. Test with: `make test` then `make coverage` to check coverage

### Fixing Test Failures
- Check `equals()` and `hashCode()` on entity classes first
- Verify `@LocalServerPort` and `RestTemplate` setup in test class
- Use `DocumentContext` (JsonPath) for JSON response parsing
- Common error: mixing `WebTestClient` (reactive) with non-reactive setup

### Database Changes
- Development: Modify `application-dev.properties` Hibernate settings or model class directly
- Production: Add migration file `V{number}__{name}.sql` in `src/main/resources/db/migration/`
- Test changes with dev profile first

### Dependency Injection Issues
- Always use constructor injection with `@Autowired` on constructor
- Check that class is annotated with `@Service`, `@Repository`, `@Component`, etc.
- Ensure Spring Boot can find classes via component scanning (package in `org.sirantar.kakebo.*`)

---

## Known Limitations & TODOs

1. **DTOs not implemented** → Entities returned directly from REST endpoints
2. **HTTP Status codes** → POST returns 200 OK instead of 201 Created
3. **Error handling** → No global exception handler implemented
4. **Validation** → No `@Valid` on @RequestBody parameters
5. **Optional handling** → Returns empty objects instead of 404 Not Found
6. **Package naming typo** → `income/applictation/` (should be `application`)
7. **Lombok** → Some classes don't use `@Data` despite manual getter/setter generation

