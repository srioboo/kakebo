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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

runtime_label() {
    case "$1" in
        docker) echo "Docker" ;;
        podman) echo "Podman" ;;
        *) echo "$1" ;;
    esac
}

runtime_is_active() {
    case "$1" in
        docker)
            command_exists docker && docker info >/dev/null 2>&1
            ;;
        podman)
            command_exists podman && podman info >/dev/null 2>&1
            ;;
        *)
            return 1
            ;;
    esac
}

runtime_available() {
    case "$1" in
        docker) command_exists docker ;;
        podman) command_exists podman ;;
        *) return 1 ;;
    esac
}

sdkman_init() {
    local sdkman_dir="${SDKMAN_DIR:-$HOME/.sdkman}"
    local sdkman_init_script="$sdkman_dir/bin/sdkman-init.sh"

    if [ ! -s "$sdkman_init_script" ]; then
        return 1
    fi

    # shellcheck disable=SC1090
    . "$sdkman_init_script" >/dev/null 2>&1
}

project_java_version() {
    if [ ! -f "$PROJECT_ROOT/.sdkmanrc" ]; then
        return 1
    fi

    grep '^java=' "$PROJECT_ROOT/.sdkmanrc" | head -n 1 | cut -d= -f2-
}

ensure_project_java() {
    local required_java
    local active_java

    required_java="$(project_java_version)"

    if [ -z "$required_java" ]; then
        print_error "No se encontró la versión Java del proyecto"
        print_info "Crea o actualiza .sdkmanrc con la versión requerida"
        return 1
    fi

    if ! command_exists sdk; then
        if ! sdkman_init; then
            print_error "SDKMAN no está disponible en este entorno"
            print_info "Instala SDKMAN o activa manualmente Java ${required_java}"
            return 1
        fi
    fi

    if ! command_exists sdk; then
        print_error "SDKMAN no está disponible en este entorno"
        print_info "Instala SDKMAN o activa manualmente Java ${required_java}"
        return 1
    fi

    if ! sdk env install >/dev/null 2>&1; then
        print_error "No se pudo activar Java ${required_java} con SDKMAN"
        print_info "Ejecuta 'sdk install java ${required_java}' y vuelve a intentarlo"
        return 1
    fi

    if ! sdk env >/dev/null 2>&1; then
        print_error "No se pudo cargar el entorno Java del proyecto"
        print_info "Ejecuta 'sdk env' manualmente desde la raíz del repositorio"
        return 1
    fi

    active_java="$(java -version 2>&1 | head -n 1)"
    print_success "Java del proyecto activado (${required_java})"
    print_info "Activo ahora: ${active_java}"
    return 0
}

wait_for_runtime() {
    local runtime="$1"
    local retries=30
    local count=0

    while [ "$count" -lt "$retries" ]; do
        if runtime_is_active "$runtime"; then
            return 0
        fi

        sleep 2
        count=$((count + 1))
    done

    return 1
}

show_runtime_selector() {
    local options=("$@")
    local selected_runtime=""
    local index=1

    print_header "Runtime requerido"
    print_info "No detectamos un runtime activo. Elige cuál quieres arrancar:"
    echo

    for runtime in "${options[@]}"; do
        case "$runtime" in
            docker)
                echo "  ${index}) Docker ($(if runtime_is_active docker; then echo activo; else echo inactivo; fi))"
                ;;
            podman)
                echo "  ${index}) Podman ($(if runtime_is_active podman; then echo activo; else echo inactivo; fi))"
                ;;
        esac
        index=$((index + 1))
    done

    echo "  q) Cancelar"
    echo

    while true; do
        read -r -p "Selecciona una opción: " choice
        case "$choice" in
            1)
                selected_runtime="${options[0]}"
                ;;
            2)
                if [ "${#options[@]}" -ge 2 ]; then
                    selected_runtime="${options[1]}"
                else
                    print_error "Opción inválida"
                    continue
                fi
                ;;
            q|Q)
                return 1
                ;;
            *)
                print_error "Opción inválida"
                continue
                ;;
        esac

        SELECTED_RUNTIME="$selected_runtime"
        return 0
    done
}

start_runtime() {
    local runtime="$1"

    print_header "Preparando $(runtime_label "$runtime")"

    case "$runtime" in
        docker)
            if [[ "$OSTYPE" == darwin* ]]; then
                if command_exists open; then
                    print_info "Abriendo Docker Desktop..."
                    open -a Docker >/dev/null 2>&1 || open -a "Docker Desktop" >/dev/null 2>&1 || true
                else
                    print_error "No se pudo abrir Docker Desktop automáticamente"
                fi
            else
                if command_exists systemctl; then
                    if systemctl --user start docker >/dev/null 2>&1 || systemctl start docker >/dev/null 2>&1; then
                        print_info "Solicitado arranque de Docker"
                    else
                        print_error "No se pudo arrancar Docker automáticamente"
                    fi
                else
                    print_error "No se encontró systemctl para iniciar Docker"
                fi
            fi
            ;;
        podman)
            if command_exists podman; then
                if [[ "$OSTYPE" == darwin* ]]; then
                    print_info "Arrancando Podman machine..."
                    podman machine start >/dev/null 2>&1 || true
                else
                    if command_exists systemctl && systemctl --user start podman >/dev/null 2>&1; then
                        print_info "Solicitado arranque de Podman"
                    else
                        print_info "Intentando arrancar Podman machine..."
                        podman machine start >/dev/null 2>&1 || true
                    fi
                fi
            else
                print_error "No se encontró el comando podman"
            fi
            ;;
        *)
            print_error "Runtime desconocido: $runtime"
            return 1
            ;;
    esac

    print_info "Esperando a que $(runtime_label "$runtime") esté listo..."
    if wait_for_runtime "$runtime"; then
        print_success "$(runtime_label "$runtime") está listo"
        return 0
    fi

    print_error "$(runtime_label "$runtime") no respondió a tiempo"
    print_info "Abre $(runtime_label "$runtime") manualmente y vuelve a ejecutar el script"
    return 1
}

ensure_runtime_ready() {
    local available_runtimes=()
    local docker_available=0
    local podman_available=0
    local docker_active=0
    local podman_active=0

    if runtime_available docker; then
        docker_available=1
        available_runtimes+=("docker")
    fi

    if runtime_available podman; then
        podman_available=1
        available_runtimes+=("podman")
    fi

    runtime_is_active docker && docker_active=1
    runtime_is_active podman && podman_active=1

    if [ "$docker_available" -eq 0 ] && [ "$podman_available" -eq 0 ]; then
        print_error "No se encontró Docker ni Podman en el sistema"
        print_info "Instala Docker Desktop o Podman y vuelve a ejecutar el script"
        return 1
    fi

    if [ "${#available_runtimes[@]}" -eq 1 ] && runtime_is_active "${available_runtimes[0]}"; then
        print_success "$(runtime_label "${available_runtimes[0]}") ya está activo"
        return 0
    fi

    if ! show_runtime_selector "${available_runtimes[@]}"; then
        return 1
    fi

    if runtime_is_active "$SELECTED_RUNTIME"; then
        print_success "$(runtime_label "$SELECTED_RUNTIME") ya está activo"
        return 0
    fi

    start_runtime "$SELECTED_RUNTIME"
}

# Iniciar backend
start_backend() {
    print_header "Iniciando Backend (Spring Boot)"

    if ! ensure_runtime_ready; then
        return 1
    fi

    if ! ensure_project_java; then
        return 1
    fi
    
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

    if ! ensure_runtime_ready; then
        return 1
    fi

    if ! ensure_project_java; then
        return 1
    fi
    
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
    echo -e "${BLUE}Kakebo Development Helper${NC}"
    echo ""
    echo -e "Uso: ./dev.sh [comando]"
    echo ""
    echo -e "${YELLOW}Comandos:${NC}"
    echo -e "    ${GREEN}start-backend${NC}     Inicia solo el backend (Spring Boot)"
    echo -e "    ${GREEN}start-frontend${NC}    Inicia solo el frontend (SvelteKit)"
    echo -e "    ${GREEN}start${NC}             Inicia backend y frontend (recomendado)"
    echo -e "    ${GREEN}stop${NC}              Detiene todos los servicios"
    echo -e "    ${GREEN}restart${NC}           Reinicia todos los servicios"
    echo -e "    ${GREEN}status${NC}            Muestra el estado de los servicios"
    echo -e "    ${GREEN}logs${NC}              Muestra los logs del backend"
    echo -e "    ${GREEN}help${NC}              Muestra esta ayuda"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo -e "    ./dev.sh start              # Inicia todo"
    echo -e "    ./dev.sh start-backend      # Solo backend"
    echo -e "    ./dev.sh status             # Ver qué está corriendo"
    echo -e "    ./dev.sh logs               # Ver logs del backend"
    echo ""
    echo -e "${YELLOW}Notas:${NC}"
    echo -e "    - El primer inicio puede tardar más (descarga dependencias)"
    echo -e "    - El arranque comprueba Docker/Podman y te pide elegir si ambos están disponibles"
    echo -e "    - SDKMAN activa Java 21.0.2-graalce automáticamente antes de iniciar el backend"
    echo -e "    - Frontend está en http://localhost:5173"
    echo -e "    - Backend está en http://localhost:9090"
    echo -e "    - Swagger en http://localhost:9090/swagger-ui.html"
    echo ""
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
