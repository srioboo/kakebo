#!/bin/bash
# Kakebo Development Helper Script
# Uso: ./dev.sh [start|stop|restart|logs|status|help]

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_ROOT/kakebo-backend"
FRONTEND_DIR="$PROJECT_ROOT/kakebo-front"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir títulos
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Función para imprimir éxito
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para imprimir error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Función para imprimir info
print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Iniciar backend
start_backend() {
    print_header "Iniciando Backend (Spring Boot)"
    
    if [ -d "$BACKEND_DIR" ]; then
        cd "$BACKEND_DIR"
        print_info "Puerto: http://localhost:9090"
        print_info "Swagger: http://localhost:9090/swagger-ui.html"
        print_info "Presiona Ctrl+C para detener"
        echo ""
        
        if [ -f "Makefile" ]; then
            make start
        else
            ./mvnw spring-boot:run -Dspring.profiles.active=dev
        fi
    else
        print_error "Directorio backend no encontrado: $BACKEND_DIR"
        exit 1
    fi
}

# Iniciar frontend
start_frontend() {
    print_header "Iniciando Frontend (SvelteKit)"
    
    if [ -d "$FRONTEND_DIR" ]; then
        cd "$FRONTEND_DIR"
        
        # Verificar si node_modules existe
        if [ ! -d "node_modules" ]; then
            print_info "Instalando dependencias..."
            npm install --legacy-peer-deps
        fi
        
        print_info "Puerto: http://localhost:5173"
        print_info "Hot reload: activado"
        print_info "Presiona Ctrl+C para detener"
        echo ""
        
        npm run dev
    else
        print_error "Directorio frontend no encontrado: $FRONTEND_DIR"
        exit 1
    fi
}

# Iniciar ambos servicios en background
start_all() {
    print_header "Kakebo Development Environment"
    
    # Verificar puerto 9090
    if lsof -Pi :9090 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_error "Puerto 9090 ya está en uso (backend)"
        return 1
    fi
    
    # Verificar puerto 5173
    if lsof -Pi :5173 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_error "Puerto 5173 ya está en uso (frontend)"
        return 1
    fi
    
    print_info "Iniciando Backend..."
    cd "$BACKEND_DIR"
    
    if [ -f "Makefile" ]; then
        make start > /tmp/kakebo-backend.log 2>&1 &
    else
        ./mvnw spring-boot:run -Dspring.profiles.active=dev > /tmp/kakebo-backend.log 2>&1 &
    fi
    
    BACKEND_PID=$!
    print_success "Backend iniciado (PID: $BACKEND_PID)"
    
    # Esperar a que el backend esté listo
    print_info "Esperando a que el backend esté listo..."
    sleep 5
    
    if ! curl -s http://localhost:9090/expenses > /dev/null 2>&1; then
        print_error "Backend no responde"
        kill $BACKEND_PID 2>/dev/null || true
        return 1
    fi
    
    print_success "Backend está listo"
    
    # Iniciar frontend
    print_info "Iniciando Frontend..."
    cd "$FRONTEND_DIR"
    
    if [ ! -d "node_modules" ]; then
        npm install --legacy-peer-deps > /dev/null 2>&1
    fi
    
    npm run dev > /tmp/kakebo-frontend.log 2>&1 &
    FRONTEND_PID=$!
    print_success "Frontend iniciado (PID: $FRONTEND_PID)"
    
    # Esperar a que el frontend esté listo
    print_info "Esperando a que el frontend esté listo..."
    sleep 5
    
    if ! curl -s http://localhost:5173 > /dev/null 2>&1; then
        print_error "Frontend no responde"
        kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
        return 1
    fi
    
    print_success "Frontend está listo"
    
    # Guardar PIDs
    echo "$BACKEND_PID" > /tmp/kakebo-backend.pid
    echo "$FRONTEND_PID" > /tmp/kakebo-frontend.pid
    
    echo ""
    print_header "🚀 Kakebo está listo!"
    echo -e "${GREEN}Frontend:${NC}  http://localhost:5173"
    echo -e "${GREEN}Backend:${NC}   http://localhost:9090"
    echo -e "${GREEN}Swagger:${NC}   http://localhost:9090/swagger-ui.html"
    echo ""
    echo -e "Presiona ${YELLOW}Ctrl+C${NC} para detener todos los servicios"
    echo ""
    
    # Esperar a que el usuario interrumpa
    wait
}

# Detener servicios
stop_all() {
    print_header "Deteniendo servicios..."
    
    if [ -f /tmp/kakebo-backend.pid ]; then
        BACKEND_PID=$(cat /tmp/kakebo-backend.pid)
        if kill -0 $BACKEND_PID 2>/dev/null; then
            kill $BACKEND_PID 2>/dev/null || true
            print_success "Backend detenido"
        fi
        rm /tmp/kakebo-backend.pid
    fi
    
    if [ -f /tmp/kakebo-frontend.pid ]; then
        FRONTEND_PID=$(cat /tmp/kakebo-frontend.pid)
        if kill -0 $FRONTEND_PID 2>/dev/null; then
            kill $FRONTEND_PID 2>/dev/null || true
            print_success "Frontend detenido"
        fi
        rm /tmp/kakebo-frontend.pid
    fi
    
    echo ""
}

# Ver estado
status() {
    print_header "Estado de servicios"
    
    if lsof -Pi :9090 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_success "Backend está corriendo en http://localhost:9090"
    else
        print_error "Backend no está corriendo"
    fi
    
    if lsof -Pi :5173 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_success "Frontend está corriendo en http://localhost:5173"
    else
        print_error "Frontend no está corriendo"
    fi
    
    echo ""
}

# Ver logs
logs() {
    print_header "Logs de Backend"
    if [ -f /tmp/kakebo-backend.log ]; then
        tail -f /tmp/kakebo-backend.log
    else
        print_error "No hay logs disponibles"
    fi
}

# Mostrar ayuda
show_help() {
    cat << EOF
${BLUE}Kakebo Development Helper${NC}

Uso: ./dev.sh [comando]

Comandos:
    ${GREEN}start-backend${NC}     Inicia solo el backend (Spring Boot)
    ${GREEN}start-frontend${NC}    Inicia solo el frontend (SvelteKit)
    ${GREEN}start${NC}             Inicia backend y frontend (recomendado)
    ${GREEN}stop${NC}              Detiene todos los servicios
    ${GREEN}restart${NC}           Reinicia todos los servicios
    ${GREEN}status${NC}            Muestra el estado de los servicios
    ${GREEN}logs${NC}              Muestra los logs del backend
    ${GREEN}help${NC}              Muestra esta ayuda

Ejemplos:
    ./dev.sh start              # Inicia todo
    ./dev.sh start-backend      # Solo backend
    ./dev.sh status             # Ver qué está corriendo
    ./dev.sh logs               # Ver logs del backend

${YELLOW}Notas:${NC}
    - El primer inicio puede tardar más (descarga dependencias)
    - Frontend está en http://localhost:5173
    - Backend está en http://localhost:9090
    - Swagger en http://localhost:9090/swagger-ui.html

EOF
}

# Main
case "${1:-start}" in
    start-backend)
        start_backend
        ;;
    start-frontend)
        start_frontend
        ;;
    start|"")
        start_all
        ;;
    stop)
        stop_all
        ;;
    restart)
        stop_all
        sleep 2
        start_all
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Comando desconocido: $1"
        show_help
        exit 1
        ;;
esac
