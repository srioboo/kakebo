# Usage

Quick start (repository-level):

1. Start both services (macOS/Linux):

```bash
./dev.sh start
```

2. Or start backend and frontend manually:

```bash
# Backend
cd kakebo-backend
./mvnw spring-boot:run -Dspring.profiles.active=dev

# Frontend (another terminal)
cd kakebo-front
npm install
npm run dev
```

3. Frontend expects the backend base URL in `kakebo-front/.env.local`:

```
VITE_API_BASE_URL=http://localhost:9090
```

Ports:
- Frontend: 5173
- Backend: 9090 (Swagger UI: http://localhost:9090/swagger-ui.html)

Troubleshooting: see subproject READMEs and `kakebo-backend/docs/00_INDEX.md` for backend-specific guides.
