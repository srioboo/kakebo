# 🧪 Testing & Errores Comunes - Kakebo Backend

**Última actualización:** 3 de Abril de 2026

## Testing Framework & Patrones

### Setup Recomendado

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IncomeRestTest {
    
    // ✅ CORRECTO: @LocalServerPort inyecta el puerto random
    @LocalServerPort
    private int port;
    
    private String baseUrl;
    
    // ✅ CORRECTO: Instancia local, NO @Autowired
    private RestTemplate restTemplate = new RestTemplate();
    
    @BeforeEach
    void setUp() {
        baseUrl = "http://localhost:" + port;
    }
    
    @Test
    void testGetIncome() {
        var response = restTemplate.getForEntity(baseUrl + "/incomes/1", String.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }
}
```

### ❌ EVITAR: WebTestClient en Spring Boot 4.x

```java
// ❌ NO FUNCIONA EN SPRING BOOT 4.x
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IncomeRestTest {
    @Autowired
    private WebTestClient webTestClient;  // ❌ No es un bean registrado!
    
    @Test
    void testGetIncome() {
        // Lanza: UnsatisfiedDependencyException
        // Razón: Spring Boot 4.x removió WebTestClient bean registration
    }
}
```

---

## JSON Response Testing (JsonPath)

### Parsear y Extraer Datos

```java
@Test
void testGetIncome() {
    var response = restTemplate.getForEntity(baseUrl + "/incomes/1", String.class);
    
    // ✅ Usar DocumentContext (JsonPath) para navegar JSON
    DocumentContext doc = JsonPath.parse(response.getBody());
    
    // Extraer valores
    Number id = doc.read("$.id");
    String name = doc.read("$.incomeName");
    Object amount = doc.read("$.amount");
    
    // Assertions
    assertThat(id).isEqualTo(1);
    assertThat(name).isEqualTo("Salary");
}
```

### Arrays en JSON

```java
@Test
void testListIncomes() {
    var response = restTemplate.getForEntity(baseUrl + "/incomes", String.class);
    DocumentContext doc = JsonPath.parse(response.getBody());
    
    // Leer array
    List<Map> incomes = doc.read("$[*]");
    assertThat(incomes).hasSize(2);
    
    // Acceder a elemento específico
    Number firstId = doc.read("$[0].id");
    assertThat(firstId).isEqualTo(1);
}
```

---

## ⚠️ Errores Comunes en Tests

### Error 1: Comparar Tipos Diferentes

#### ❌ INCORRECTO
```java
BigDecimal amount = BigDecimal.valueOf(100);
assertThat(amount).isEqualTo(100L);        // ❌ BigDecimal vs Long
assertThat(amount).isEqualTo(100);         // ❌ BigDecimal vs int
```

#### ✅ CORRECTO
```java
BigDecimal amount = BigDecimal.valueOf(100);
assertThat(amount).isEqualTo(BigDecimal.valueOf(100));  // ✅ BigDecimal vs BigDecimal
assertThat(amount).isEqualTo(BigDecimal.TEN.multiply(BigDecimal.TEN));
```

---

### Error 2: Comparar LocalDateTime con String

#### ❌ INCORRECTO
```java
LocalDateTime date = LocalDateTime.of(2025, 1, 1, 0, 0);
assertThat(date).isEqualTo("2025-01-01T00:00:00");  // ❌ Tipos diferentes
```

#### ✅ CORRECTO
```java
LocalDateTime date = LocalDateTime.of(2025, 1, 1, 0, 0);
assertThat(date).isEqualTo(LocalDateTime.of(2025, 1, 1, 0, 0));  // ✅ Mismo tipo

// O parsear el string
String dateStr = "2025-01-01T00:00:00";
LocalDateTime parsed = LocalDateTime.parse(dateStr);
assertThat(date).isEqualTo(parsed);
```

---

### Error 3: Copy/Paste sin Verificar Valores

#### ❌ INCORRECTO
```java
// En ExpenseJsonTest
private static final Expenses EXPENSE = new Expenses(..., "expense 1", ...);

@Test
void deserializationTest() {
    // Copiado de IncomeJsonTest sin cambiar
    assertThat(expense.getName()).isEqualTo("income 1");  // ❌ Valor incorrecto
}
```

#### ✅ CORRECTO
```java
// En ExpenseJsonTest
private static final Expenses EXPENSE = new Expenses(..., "expense 1", ...);

@Test
void deserializationTest() {
    assertThat(expense.getName()).isEqualTo("expense 1");  // ✅ Valor correcto
}
```

**Consejo**: Siempre verifica los valores en el objeto de prueba definido arriba del test.

---

### Error 4: Typos en Nombres de Métodos

#### ❌ INCORRECTO
```java
@Test
void deserializationExperensesTest() {  // ❌ Typo: "Expeenses"
    // Este método existe pero el nombre es confuso
}
```

#### ✅ CORRECTO
```java
@Test
void deserializationExpensesTest() {  // ✅ Nombre correcto
    // El IDE detectará el typo automáticamente
}
```

---

### Error 5: equals() y hashCode() No Implementados

#### ❌ INCORRECTO
```java
Expenses obj1 = new Expenses(1, BigDecimal.TEN, "exp", LocalDateTime.of(2025,1,1,0,0));
Expenses obj2 = new Expenses(1, BigDecimal.TEN, "exp", LocalDateTime.of(2025,1,1,0,0));

assertThat(obj1).isEqualTo(obj2);  // ❌ FALLA aunque valores sean iguales
// Razón: equals() usa == (comparación de referencias) por defecto
```

#### ✅ CORRECTO
Implementar `equals()` y `hashCode()` en la entidad:

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

Ahora los tests pasarán:
```java
Expenses obj1 = new Expenses(...);
Expenses obj2 = new Expenses(...);  // Mismos valores

assertThat(obj1).isEqualTo(obj2);  // ✅ PASA
```

---

## CheatSheet: Errores y Soluciones

| Error | Síntoma | Solución |
|-------|---------|----------|
| Tipos diferentes | `AssertionError: expected <100> but was <BigDecimal 100>` | Usa `BigDecimal.valueOf()` o `BigDecimal.TEN` |
| LocalDateTime vs String | `AssertionError` en comparación de fechas | Usa `LocalDateTime.of()` o parsea el string |
| Copy/Paste | Tests fallan con valores inesperados | Verifica valores en el objeto de prueba |
| Typo en método | Test no se ejecuta | IDE destaca automáticamente |
| Sin equals/hashCode | Comparaciones por referencia fallan | Implementa ambos métodos |
| WebTestClient | `UnsatisfiedDependencyException` | Usa `RestTemplate` en lugar |
| @LocalServerPort | NullPointerException | Usa `RANDOM_PORT` en @SpringBootTest |

---

## Ejemplo Completo: Test REST

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IncomeRestTest {
    
    @LocalServerPort
    private int port;
    
    private String baseUrl;
    private RestTemplate restTemplate = new RestTemplate();
    
    private static final Incomes INCOME = new Incomes(
        1, 
        BigDecimal.TEN, 
        "Salary", 
        LocalDateTime.of(2025, 1, 1, 0, 0, 0)
    );
    
    @BeforeEach
    void setUp() {
        baseUrl = "http://localhost:" + port;
    }
    
    @Test
    void testGetIncome() {
        // GET
        var response = restTemplate.getForEntity(
            baseUrl + "/incomes/1", 
            String.class
        );
        
        // Verificar status
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        
        // Parsear JSON
        DocumentContext doc = JsonPath.parse(response.getBody());
        
        // Extraer y verificar datos
        Number id = doc.read("$.id");
        String name = doc.read("$.incomeName");
        
        assertThat(id).isEqualTo(1);
        assertThat(name).isEqualTo("Salary");
    }
    
    @Test
    void testCreateIncome() {
        // POST
        var response = restTemplate.postForEntity(
            baseUrl + "/incomes",
            INCOME,
            Incomes.class
        );
        
        // Verificar status (debería ser 201, pero actualmente es 200)
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);  // TODO: cambiar a 201
        
        // Verificar respuesta
        Incomes created = response.getBody();
        assertThat(created).isNotNull();
        assertThat(created.getIncomeName()).isEqualTo("Salary");
    }
}
```

---

## 🔨 Comandos para Testing

```bash
# Ejecutar todos los tests
make test
# O: ./mvnw test

# Ejecutar test específico
./mvnw test -Dtest=IncomeRestTest

# Ver cobertura
make coverage
# O: ./mvnw clean test jacoco:report

# Cobertura en navegador
open target/site/jacoco/index.html
```

---

## 📚 Cosas a Recordar

1. ✅ **Siempre usa tipos correctos** en las aserciones (BigDecimal, LocalDateTime, etc.)
2. ✅ **Implementa equals() y hashCode()** en entidades JPA
3. ✅ **Usa RestTemplate** en Spring Boot 4.x (no WebTestClient)
4. ✅ **Usa JsonPath/DocumentContext** para navegar respuestas JSON
5. ✅ **Copia valores correctamente** del objeto de prueba
6. ✅ **Verifica nombres de métodos** (los IDEs detectan typos)
7. ✅ **Usa @LocalServerPort** con RANDOM_PORT para tests REST

---

## 🔗 Referencias

- [Inicio Rápido](01-Inicio-inicio-rapido.md)
- [Arquitectura & Patrones](02-Arquitectura-hexagonal-patrones.md)
- [Desarrollo & Entornos](03-Desarrollo-entornos-configuracion.md)
- [Calidad de Código](05-CalidadCodigo-sonarqube-cobertura.md)

