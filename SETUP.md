# Kakebo Development Setup
# Este archivo documenta la configuración inicial del proyecto

## ✅ Checklist de Setup Inicial

### 1. Requisitos Previos
- [ ] Java 21+ instalado (`java -version`)
- [ ] Node.js 18+ instalado (`node -v`)
- [ ] npm instalado (`npm -v`)
- [ ] Git configurado (`git config --list`)

### 2. Backend (Spring Boot)
```bash
cd kakebo-backend
# Primera vez: compilar
./mvnw clean compile

# Iniciar en modo desarrollo
./mvnw spring-boot:run -Dspring.profiles.active=dev

# Verificar que está corriendo
curl http://localhost:9090/expenses
```

**Resultado esperado:**
- Backend en `http://localhost:9090`
- Swagger en `http://localhost:9090/swagger-ui.html`
- Base de datos H2 en memoria (se recrea cada vez)

### 3. Frontend (SvelteKit)
```bash
cd kakebo-front
# Primera vez: instalar dependencias
npm install --legacy-peer-deps

# Iniciar dev server
npm run dev

# Verificar que está corriendo
curl http://localhost:5173
```

**Resultado esperado:**
- Frontend en `http://localhost:5173`
- Hot reload activado
- Conexión con backend automática

### 4. Verificar Integración
1. Abre http://localhost:5173 en el navegador
2. Ve a `/expenses` o `/incomes`
3. Intenta crear un nuevo gasto:
   - Concepto: "Test"
   - Importe: "10.50"
   - Fecha: hoy
4. Presiona "Crear Gasto"
5. Verifica que aparece en la tabla

## 🎯 Flujo de Desarrollo Recomendado

### Opción 1: Automatizado (Recomendado)
```bash
# macOS/Linux
./dev.sh start

# Windows
dev.bat start
```

### Opción 2: Manual (Control Total)
```
Terminal 1 (Backend):          Terminal 2 (Frontend):
cd kakebo-backend              cd kakebo-front
./mvnw spring-boot:run \       npm run dev
  -Dspring.profiles.active=dev
```

### Opción 3: En Segundo Plano (macOS/Linux)
```bash
# Iniciar backend en background
cd kakebo-backend && ./mvnw spring-boot:run -Dspring.profiles.active=dev > /tmp/backend.log 2>&1 &

# Iniciar frontend en background
cd kakebo-front && npm run dev > /tmp/frontend.log 2>&1 &

# Ver logs
tail -f /tmp/backend.log
tail -f /tmp/frontend.log
```

## 📝 Configuración de Variables de Entorno

### Backend
Crear `kakebo-backend/src/main/resources/application-dev.properties`:
```properties
spring.application.name=kakebo
spring.datasource.url=jdbc:h2:mem:kakebodb
spring.datasource.driverClassName=org.h2.Driver
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=create-drop
spring.h2.console.enabled=true
server.port=9090
```

### Frontend
Crear `.env.local` en `kakebo-front/`:
```
VITE_API_BASE_URL=http://localhost:9090
```

## 🔍 Verificación de Ports

### Linux/macOS
```bash
# Ver qué está usando los puertos
lsof -i :9090    # Backend
lsof -i :5173    # Frontend

# Matar procesos específicos
kill -9 <PID>
```

### Windows
```bash
# Ver qué está usando los puertos
netstat -ano | find ":9090"
netstat -ano | find ":5173"

# Matar procesos
taskkill /PID <PID> /F
```

## 🐛 Errores Comunes y Soluciones

### Error: "Port 9090 already in use"
```bash
# Encontrar y matar el proceso
# macOS/Linux:
lsof -i :9090 | grep LISTEN | awk '{print $2}' | xargs kill -9

# Windows:
netstat -ano | find ":9090" | for /f "tokens=5" %a in ('findstr /r .*') do taskkill /PID %a /F
```

### Error: "Cannot find module 'tailwindcss'"
```bash
# Reinstalar dependencias
cd kakebo-front
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

### Error: "CORS policy: No 'Access-Control-Allow-Origin' header"
- Verificar que backend está corriendo en `http://localhost:9090`
- Verificar que el frontend está en `http://localhost:5173`
- El CORS está configurado en el backend para permitir `https://localhost:5173`

### Error: "Unexpected token" en frontend
```bash
# Vaciar caché de navegador
# Presiona Ctrl+Shift+Delete en el navegador
# O reinicia el dev server:
npm run dev
```

## 📊 Estructura de Comandos Útiles

### Desarrollo
```bash
# Backend
cd kakebo-backend
make start              # Inicia app
make test               # Ejecuta tests
make lint               # Análisis estático
make help               # Todos los comandos

# Frontend
cd kakebo-front
npm run dev             # Dev server
npm run check           # Tipos + compilación
npm run lint            # ESLint + Prettier
npm run format          # Formatea código
```

### Testing
```bash
# Backend
cd kakebo-backend
./mvnw test             # Todos los tests
./mvnw test -Dtest=ExpensesControllerTest  # Test específico

# Frontend
cd kakebo-front
npm run test:unit       # Vitest
npm run test:e2e        # Playwright
npm run test            # Ambos
```

### Build
```bash
# Backend
cd kakebo-backend
./mvnw clean package -DskipTests
# JAR en: target/kakebo-0.0.1-SNAPSHOT.jar

# Frontend
cd kakebo-front
npm run build
# Build en: build/
```

## 🚀 Próximos Pasos

1. [ ] Completar setup de desarrollo
2. [ ] Probar integración backend-frontend
3. [ ] Crear primer gasto/ingreso
4. [ ] Revisar logs en `http://localhost:9090/swagger-ui.html`
5. [ ] Explorar código frontend en `/src`
6. [ ] Explorar código backend en `/kakebo-backend/src/main/java`

## 💡 Tips

- **Hot Reload**: Cambios en frontend se reflejan al guardar
- **Swagger UI**: Documenta todos los endpoints de API
- **H2 Console**: Ver base de datos en `http://localhost:9090/h2-console`
- **DevTools**: Abre F12 en el navegador para inspeccionar
- **Logs**: Mira los logs del terminal para debugging

## 📚 Documentación

- Backend: `kakebo-backend/README.md` y `kakebo-backend/docs/00_INDEX.md`
- Frontend: `kakebo-front/README.md` y `kakebo-front/AGENTS.md`
- Raíz: `README.md` (este archivo)

---

**¿Necesitas ayuda?** Revisa la sección de troubleshooting en `README.md`
