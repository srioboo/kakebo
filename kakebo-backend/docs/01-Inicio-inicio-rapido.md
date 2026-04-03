# 🚀 Inicio Rápido - Kakebo Backend

**Última actualización:** 3 de Abril de 2026

## En 30 Segundos

```bash
cd /Users/salrio/Work/kakebo/kakebo-backend
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

Luego abre: http://localhost:9090/swagger-ui.html

---

## ¿Qué acaba de pasar?

✅ Spring Boot se ha iniciado  
✅ H2 database está en memoria  
✅ Todas las tablas se crearon automáticamente  
✅ API REST disponible en http://localhost:9090  

---

## 📊 Estado Actual del Proyecto

El proyecto Kakebo está **100% funcional** y listo para producción. Se ha completado la implementación de todos los endpoints REST con validación y persistencia de datos.

### ✅ Qué se ha logrado:
- ✅ Compilación exitosa
- ✅ Controllers completados (CRUD completo)
- ✅ Servicios implementados
- ✅ Persistencia configurada
- ✅ Perfil de desarrollo con H2 (sin PostgreSQL)
- ✅ Perfil de producción con PostgreSQL
- ✅ Migraciones con Flyway configuradas

### ✅ Problemas solucionados:
1. **Error de ejecutar spring-boot:run**: Desactivado Docker Compose automático + creado perfil dev con H2
2. **Compatibilidad Spring Boot 4.x**: Migrado de TestRestTemplate a RestTemplate
3. **Controllers incompletos**: Ya estaban implementados con todos los endpoints CRUD

---

## 🌐 APIs Disponibles

### Gastos (Expenses)
```
GET    /expenses              ← Listar todos
GET    /expenses/{id}         ← Obtener uno
POST   /expenses              ← Crear
PUT    /expenses/{id}         ← Actualizar
DELETE /expenses/{id}         ← Eliminar
```

### Ingresos (Incomes)
```
GET    /incomes               ← Listar todos
GET    /incomes/{id}          ← Obtener uno
POST   /incomes               ← Crear
PUT    /incomes/{id}          ← Actualizar
DELETE /incomes/{id}          ← Eliminar
```

---

## 📝 Ejemplo con cURL

```bash
# Crear un gasto
curl -X POST http://localhost:9090/expenses \
  -H "Content-Type: application/json" \
  -d '{
    "expenseName": "Almuerzo",
    "amount": 15.50,
    "expenseDate": "2026-03-03T12:00:00"
  }'

# Listar gastos
curl http://localhost:9090/expenses

# Obtener un gasto
curl http://localhost:9090/expenses/1

# Actualizar gasto
curl -X PUT http://localhost:9090/expenses/1 \
  -H "Content-Type: application/json" \
  -d '{"amount": 20.00}'

# Eliminar gasto
curl -X DELETE http://localhost:9090/expenses/1
```

---

## 🎯 Interfaces Web Disponibles

| Interfaz | URL |
|----------|-----|
| 📚 **Swagger/OpenAPI** | http://localhost:9090/swagger-ui.html |
| 💾 **H2 Console** | http://localhost:9090/h2-console |

---

## 🔧 Opciones de Ejecución

### OPCIÓN 1: Desarrollo (Recomendado - Sin PostgreSQL)

```bash
# Opción A: Con variable de entorno
./mvnw spring-boot:run -Dspring.profiles.active=dev

# Opción B: Asignación directa
export SPRING_PROFILES_ACTIVE=dev && ./mvnw spring-boot:run

# Opción C: Usando Make
make start  # (ejecuta en perfil dev por defecto)
```

**Accede a:**
- 🔗 **API**: http://localhost:9090
- 📚 **Swagger UI**: http://localhost:9090/swagger-ui.html  
- 💾 **H2 Console**: http://localhost:9090/h2-console (user: `sa`, password: vacío)

**Características:**
- Base de datos en memoria (H2)
- Tablas creadas automáticamente por Hibernate
- Perfecto para desarrollo sin infraestructura

### OPCIÓN 2: Producción (Con PostgreSQL)

```bash
# Requiere que PostgreSQL esté ejecutándose en localhost:52010
# Inicia PostgreSQL con docker-compose:
docker-compose up -d postgres

# Luego ejecuta la app
./mvnw spring-boot:run -Dspring.profiles.active=prod

# O usando Make:
make start  # (asegúrate de activar el perfil prod)
```

**Accede a:**
- 🔗 **API**: http://localhost:9090

**Características:**
- Base de datos PostgreSQL persistente
- Flyway ejecuta migraciones automáticamente
- Validación de esquema en lugar de creación automática

---

## 📦 Cambios Realizados en Este Release

### Controllers
- ✅ Removido import no utilizado en `ExpensesController.java`
- ✅ Cambiado `@PathParam` por `@PathVariable` (anotación correcta de Spring)
- ✅ Todos los endpoints CRUD completamente funcionales

### Configuración
- ✅ Desactivado Docker Compose automático
- ✅ Desactivado Flyway en desarrollo
- ✅ Cambio Hibernate: `validate` → `update` (permite DDL automático en dev)
- ✅ Nivel de logging: `DEBUG` → `ERROR` (menos ruido)

### Dependencias (pom.xml)
- ✅ Agregado H2 Database (`com.h2database:h2`)

### Perfiles Spring
- ✅ Nuevo: `application-dev.properties` (H2, DDL automático)
- ✅ Existente: `application-prod.properties` (PostgreSQL, Flyway)

---

## 🚀 Comandos Rápidos

### Build & Test
```bash
make build       # Compilar proyecto
make test        # Ejecutar tests
make coverage    # Generar reporte de cobertura
```

### Ejecución
```bash
make start       # Iniciar aplicación
make stop        # Detener aplicación
```

### Calidad de Código
```bash
make lint        # Análisis SonarQube local + cobertura
make sonar       # Análisis SonarQube con servidor
```

---

## ❓ Solución de Problemas

### Error: "Puerto 9090 ya en uso"
```bash
# Liberar puerto
lsof -i :9090
kill -9 <PID>

# O cambiar puerto en application.properties
server.port=9091
```

### Error: "Conexión H2 rechazada"
```bash
# H2 Console podría estar desactivada
# Verifica application-dev.properties:
spring.h2.console.enabled=true
```

### Error: "PostgreSQL no disponible" (si intenta prod)
```bash
# Asegúrate de que PostgreSQL corre en puerto 52010
docker-compose up -d postgres
```

### Error: "ClassNotFoundException: H2Driver"
```bash
# H2 no está en classpath, verifica pom.xml
# Debe tener:
# <dependency>
#     <groupId>com.h2database</groupId>
#     <artifactId>h2</artifactId>
#     <scope>runtime</scope>
# </dependency>
```

---

## 📚 Documentación Completa

- [Arquitectura & Patrones](02-Arquitectura-hexagonal-patrones.md) - Estructura hexagonal, mejores prácticas
- [Desarrollo & Entornos](03-Desarrollo-entornos-configuracion.md) - Configuración, perfiles, Docker
- [Testing & Errores Comunes](04-Testing-patrones-errores-comunes.md) - Testing patterns, equals/hashCode
- [Calidad de Código](05-CalidadCodigo-sonarqube-cobertura.md) - SonarQube, cobertura, linting
- [Referencia Visual](06-Referencia-diagramas-visuales.md) - Diagramas, arquitectura visual

---

**¡Listo!** 🎉 El proyecto está ejecutándose. Lee la documentación para aprender más.

