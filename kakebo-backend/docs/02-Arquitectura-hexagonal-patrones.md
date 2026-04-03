# 🏗️ Arquitectura & Patrones - Kakebo Backend

**Última actualización:** 3 de Abril de 2026

## Arquitectura Hexagonal (Puertos & Adaptadores)

El proyecto Kakebo sigue el patrón de arquitectura hexagonal, donde el negocio (dominio) está aislado de las dependencias externas.

### Estructura de Capas

```
src/main/java/org/sirantar/kakebo/
├── expenses/                          # DOMINIO 1: Gastos
│   ├── domain/
│   │   ├── model/
│   │   │   └── Expenses.java         # Entidad de negocio
│   │   └── repository/
│   │       └── ExpensesRepository.java # Puerto (interfaz)
│   ├── application/
│   │   └── service/
│   │       └── ExpensesService.java  # Lógica de negocio
│   └── infrastructure/
│       └── rest/
│           └── ExpensesController.java # Adaptador REST
│
├── income/                            # DOMINIO 2: Ingresos
│   ├── domain/
│   │   ├── model/
│   │   │   └── Incomes.java          # Entidad de negocio
│   │   └── repository/
│   │       └── IncomeRepository.java  # Puerto (interfaz)
│   ├── applictation/                  # ⚠️ NOTA: typo en nombre (applictation)
│   │   └── service/
│   │       └── IncomeService.java    # Lógica de negocio
│   └── infrastructure/
│       └── rest/
│           └── IncomeController.java # Adaptador REST
│
└── KakeboApplication.java             # Punto de entrada Spring
```

### Explicación de Capas

| Capa | Responsabilidad | Ejemplo |
|------|-----------------|---------|
| **domain/model** | Entidades JPA del negocio | `Expenses`, `Incomes` |
| **domain/repository** | Interfaces de acceso a datos | `ExpensesRepository extends CrudRepository` |
| **application/service** | Lógica de negocio pura | `ExpensesService.createExpense()` |
| **infrastructure/rest** | Adaptadores a protocolos (HTTP) | `@RestController`, `@GetMapping` |

### Ventajas de Esta Arquitectura

✅ **Aislamiento**: La lógica de negocio no depende de Spring  
✅ **Testabilidad**: Fácil mockear repositorios en tests  
✅ **Escalabilidad**: Agregar nuevas formas de acceso (gRPC, GraphQL) sin tocar el dominio  
✅ **Mantenibilidad**: Cada capa tiene una responsabilidad clara  

---

## Entidades del Dominio

### Expenses (Gastos)

```java
@Entity
@Table(name = "expenses")
public class Expenses {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private BigDecimal amount;      // Monto del gasto
    private String expenseName;     // Descripción
    private LocalDateTime expenseDate; // Fecha y hora
}
```

**Campos:**
- `id` (Long): Identificador único, autoincremental
- `amount` (BigDecimal): Cantidad gastada
- `expenseName` (String): Descripción del gasto
- `expenseDate` (LocalDateTime): Cuándo se realizó el gasto

### Incomes (Ingresos)

```java
@Entity
@Table(name = "incomes")
public class Incomes {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private BigDecimal amount;      // Monto del ingreso
    private String incomeName;      // Descripción
    private LocalDateTime expenseDate; // Fecha y hora (reutiliza nombre de Expenses)
}
```

**Nota:** El campo `expenseDate` se reutiliza para ambas entidades (nombre poco ideal pero funcional)

### ⚠️ Critical: equals() y hashCode()

**Ambas entidades DEBEN implementar `equals()` y `hashCode()`** para que los tests funcionen correctamente:

```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    
    Expenses expenses = (Expenses) o;
    
    if (id != null ? !id.equals(expenses.id) : expenses.id != null) return false;
    if (amount != null ? !amount.equals(expenses.amount) : expenses.amount != null) return false;
    if (expenseName != null ? !expenseName.equals(expenses.expenseName) : expenses.expenseName != null)
        return false;
    return expenseDate != null ? expenseDate.equals(expenses.expenseDate) : expenses.expenseDate == null;
}

@Override
public int hashCode() {
    int result = id != null ? id.hashCode() : 0;
    result = 31 * result + (amount != null ? amount.hashCode() : 0);
    result = 31 * result + (expenseName != null ? expenseName.hashCode() : 0);
    result = 31 * result + (expenseDate != null ? expenseDate.hashCode() : 0);
    return result;
}
```

Sin estos métodos, comparaciones como `assertThat(obj1).isEqualTo(obj2)` fallarán aunque tengan los mismos valores.

---

## Patrones de Diseño Implementados

### Patrón 1: Constructor Injection (Inyección por Constructor)

```java
// ❌ EVITAR: Field Injection
@Service
public class ExpensesService {
    @Autowired
    private ExpensesRepository repository; // Campo inyectado
}

// ✅ PREFERIR: Constructor Injection
@Service
public class ExpensesService {
    private final ExpensesRepository repository;
    
    @Autowired
    public ExpensesService(ExpensesRepository repository) {
        this.repository = repository;
    }
}
```

**Ventajas:**
- Dependencias explícitas
- Facilita testing (puedes pasar mocks por constructor)
- Permite fields `final` (inmutabilidad)

### Patrón 2: Optional Handling

```java
// ❌ ACTUAL: Retorna objeto vacío
Optional<Expenses> found = repository.findById(id);
return found.orElse(new Expenses()); // Retorna Expenses vacío si no existe

// ✅ MEJOR: Retorna excepción o null
return found.orElseThrow(() -> 
    new ResourceNotFoundException("Expense with id " + id + " not found"));
```

### Patrón 3: Service Layer

```java
@Service
public class ExpensesService {
    private final ExpensesRepository repository;
    
    public Iterable<Expenses> getExpenses() {
        // Lógica de negocio (validaciones, transformaciones)
        return repository.findAll();
    }
    
    public Expenses createExpense(Expenses expense) {
        // Validar, transformar, etc.
        return repository.save(expense);
    }
    
    public Expenses updateExpense(Long id, Expenses updates) {
        // Lógica de merge
        Optional<Expenses> existing = repository.findById(id);
        if (existing.isPresent()) {
            Expenses expense = existing.get();
            if (updates.getAmount() != null) {
                expense.setAmount(updates.getAmount());
            }
            // ... más actualizaciones
            return repository.save(expense);
        }
        return null; // TODO: retornar excepción
    }
}
```

---

## Controladores REST

### ExpensesController

```java
@RestController
@CrossOrigin(origins = "https://localhost:5173") // Para frontend en localhost:5173
@RequestMapping("/")
public class ExpensesController {
    private final ExpensesService service;
    
    @Autowired
    public ExpensesController(ExpensesService service) {
        this.service = service;
    }
    
    @GetMapping("/expenses")
    @Operation(summary = "Get all expenses")
    public ResponseEntity<Iterable<Expenses>> getExpenses() {
        return ResponseEntity.ok(service.getExpenses());
    }
    
    @GetMapping("/expenses/{id}")
    @Operation(summary = "Get expense by ID")
    public Expenses getExpenseById(@PathVariable Long id) {
        return service.getExpenseById(id);
    }
    
    @PostMapping("/expenses")
    @Operation(summary = "Create expense")
    public ResponseEntity<Expenses> createExpense(@RequestBody Expenses expense) {
        return ResponseEntity.ok(service.createExpense(expense));
    }
    
    // PUT, DELETE, etc.
}
```

### IncomeController

```java
@RestController
@RequestMapping("/")
public class IncomeController {
    private final IncomeService service;
    
    @Autowired
    public IncomeController(IncomeService service) {
        this.service = service;
    }
    
    @GetMapping("/incomes")
    @Operation(summary = "Get all incomes")
    public ResponseEntity<Iterable<Incomes>> getIncomes() {
        return ResponseEntity.ok(service.getIncomes());
    }
    
    // Resto de endpoints...
}
```

**Nota:** `ExpensesController` tiene `@CrossOrigin` para el frontend en localhost:5173, `IncomeController` no la tiene (TODO: sincronizar)

---

## 🏢 Mejores Prácticas de Spring Boot Implementadas

### 1. Application Properties Profiles

#### Estructura
```
src/main/resources/
├── application.properties          # Configuración común
├── application-dev.properties      # Desarrollo (H2)
├── application-prod.properties     # Producción (PostgreSQL)
└── application-test.properties     # Testing
```

#### application.properties (Común)

```properties
spring.application.name=kakebo
server.port=9090

# Swagger/OpenAPI
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.api-docs.path=/v3/api-docs

# Logging por defecto
logging.level.root=ERROR
logging.level.org.springframework.web=INFO
logging.level.org.sirantar.kakebo=INFO
```

#### application-dev.properties

```properties
# Desarrollo: H2 en memoria
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# H2 Console
spring.h2.console.enabled=true

# Auto-crear tablas
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.show-sql=true

# Logging verboso
logging.level.org.springframework.web=DEBUG
logging.level.org.sirantar.kakebo=DEBUG
logging.level.org.hibernate.SQL=DEBUG

# Sin Flyway (DDL automático)
spring.flyway.enabled=false
```

#### application-prod.properties

```properties
# Producción: PostgreSQL
spring.datasource.url=jdbc:postgresql://localhost:52010/mydatabase
spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.username=myuser
spring.datasource.password=secret

# Connection Pool (HikariCP)
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30s

# JPA: validar, no crear
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.show-sql=false

# Flyway: aplicar migraciones
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration

# Logging: mínimo
logging.level.root=WARN
logging.level.org.sirantar.kakebo=INFO

# Performance
spring.jpa.properties.hibernate.jdbc.batch_size=20
spring.jpa.properties.hibernate.order_inserts=true

# Graceful shutdown
server.shutdown=graceful
spring.lifecycle.timeout-per-shutdown-phase=30s
```

### 2. Activación de Perfiles

```bash
# Via Maven
./mvnw spring-boot:run -Dspring.profiles.active=dev
./mvnw spring-boot:run -Dspring.profiles.active=prod

# Via variable de entorno
export SPRING_PROFILES_ACTIVE=dev
./mvnw spring-boot:run

# Via Docker
docker run -e SPRING_PROFILES_ACTIVE=prod myapp:latest
```

---

## 📝 Cambios Realizados en This Release

### Controllers
- ✅ Removido import no utilizado `jakarta.websocket.server.PathParam`
- ✅ Cambiado `@PathParam("id")` por `@PathVariable` (anotación correcta de Spring)
- ✅ Todos los endpoints CRUD completamente funcionales

### Configuración
- ✅ Desactivado Docker Compose automático
- ✅ Desactivado Flyway en desarrollo
- ✅ Cambio Hibernate: `validate` → `update`
- ✅ Nivel de logging: `DEBUG` → `ERROR`

### Dependencias
- ✅ Agregado H2 Database

### Perfiles Spring
- ✅ Nuevo: `application-dev.properties` (H2)
- ✅ Existente: `application-prod.properties` (PostgreSQL)

---

## 🔗 Referencias

- [Inicio Rápido](01-Inicio-inicio-rapido.md)
- [Desarrollo & Entornos](03-Desarrollo-entornos-configuracion.md)
- [Testing & Errores](04-Testing-patrones-errores-comunes.md)
- [Calidad de Código](05-CalidadCodigo-sonarqube-cobertura.md)

