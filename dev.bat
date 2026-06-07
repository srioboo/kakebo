@echo off
REM Kakebo Development Helper Script for Windows
REM Uso: dev.bat [start|stop|restart|logs|status|help]

setlocal enabledelayedexpansion

set "PROJECT_ROOT=%~dp0"
set "BACKEND_DIR=%PROJECT_ROOT%kakebo-backend"
set "FRONTEND_DIR=%PROJECT_ROOT%kakebo-front"

REM ANSI Color codes (Windows 10+)
set "RESET="
set "BLUE=[34m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "RED=[31m"

REM Function-like macros for printing
set "print_header=echo. & echo %BLUE%================================%RESET% & echo %BLUE%%1%RESET% & echo %BLUE%================================%RESET% & echo."
set "print_success=echo %GREEN%[OK]%RESET% %1"
set "print_error=echo %RED%[ERROR]%RESET% %1"
set "print_info=echo %YELLOW%[INFO]%RESET% %1"

if "%1"=="" goto start_all
if "%1"=="start" goto start_all
if "%1"=="start-backend" goto start_backend
if "%1"=="start-frontend" goto start_frontend
if "%1"=="stop" goto stop_all
if "%1"=="restart" goto restart_all
if "%1"=="status" goto status
if "%1"=="help" goto help
if "%1"=="--help" goto help
if "%1"=="-h" goto help
echo %RED%[ERROR]%RESET% Comando desconocido: %1
goto help

:start_backend
cls
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Iniciando Backend (Spring Boot)%RESET%
echo %BLUE%================================%RESET%
echo.

if not exist "%BACKEND_DIR%" (
    echo %RED%[ERROR]%RESET% Directorio backend no encontrado
    exit /b 1
)

cd /d "%BACKEND_DIR%"

call :ensure_runtime_ready
if errorlevel 1 exit /b 1

echo %YELLOW%[INFO]%RESET% Puerto: http://localhost:9090
echo %YELLOW%[INFO]%RESET% Swagger: http://localhost:9090/swagger-ui.html
echo %YELLOW%[INFO]%RESET% Presiona Ctrl+C para detener
echo.

if exist "Makefile" (
    call make start
) else (
    call mvnw spring-boot:run -Dspring.profiles.active=dev
)
exit /b %errorlevel%

:start_frontend
cls
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Iniciando Frontend (SvelteKit)%RESET%
echo %BLUE%================================%RESET%
echo.

if not exist "%FRONTEND_DIR%" (
    echo %RED%[ERROR]%RESET% Directorio frontend no encontrado
    exit /b 1
)

cd /d "%FRONTEND_DIR%"

if not exist "node_modules" (
    echo %YELLOW%[INFO]%RESET% Instalando dependencias...
    call npm install --legacy-peer-deps
)

echo %YELLOW%[INFO]%RESET% Puerto: http://localhost:5173
echo %YELLOW%[INFO]%RESET% Hot reload: activado
echo %YELLOW%[INFO]%RESET% Presiona Ctrl+C para detener
echo.

call npm run dev
exit /b %errorlevel%

:start_all
cls
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Kakebo Development Environment%RESET%
echo %BLUE%================================%RESET%
echo.

REM Simplemente abrir dos ventanas de comando
echo %YELLOW%[INFO]%RESET% Abriendo ventanas de terminal...
echo.

call :ensure_runtime_ready
if errorlevel 1 exit /b 1

REM Backend
start "Kakebo Backend" cmd /k "cd /d "%BACKEND_DIR%" && (if exist Makefile (make start) else (mvnw spring-boot:run -Dspring.profiles.active=dev))"

REM Esperar un poco
timeout /t 3 /nobreak

REM Frontend
start "Kakebo Frontend" cmd /k "cd /d "%FRONTEND_DIR%" && (if not exist node_modules npm install --legacy-peer-deps) && npm run dev"

echo %GREEN%[OK]%RESET% Servicios iniciados en nuevas ventanas
echo.
echo %GREEN%Frontend:%RESET%  http://localhost:5173
echo %GREEN%Backend:%RESET%   http://localhost:9090
echo %GREEN%Swagger:%RESET%   http://localhost:9090/swagger-ui.html
echo.
exit /b 0

:ensure_runtime_ready
set "DOCKER_AVAILABLE=0"
set "PODMAN_AVAILABLE=0"
set "DOCKER_ACTIVE=0"
set "PODMAN_ACTIVE=0"

where docker >nul 2>&1 && set "DOCKER_AVAILABLE=1"
where podman >nul 2>&1 && set "PODMAN_AVAILABLE=1"

docker info >nul 2>&1 && set "DOCKER_ACTIVE=1"
podman info >nul 2>&1 && set "PODMAN_ACTIVE=1"

if "%DOCKER_AVAILABLE%"=="0" if "%PODMAN_AVAILABLE%"=="0" (
    echo %RED%[ERROR]%RESET% No se encontró Docker ni Podman en el sistema
    echo %YELLOW%[INFO]%RESET% Instala Docker Desktop o Podman y vuelve a ejecutar el script
    exit /b 1
)

if "%DOCKER_AVAILABLE%"=="1" if "%PODMAN_AVAILABLE%"=="1" goto choose_runtime

if "%DOCKER_AVAILABLE%"=="1" if "%DOCKER_ACTIVE%"=="1" (
    echo %GREEN%[OK]%RESET% Docker ya está activo
    exit /b 0
)

if "%PODMAN_AVAILABLE%"=="1" if "%PODMAN_ACTIVE%"=="1" (
    echo %GREEN%[OK]%RESET% Podman ya está activo
    exit /b 0
)

if "%DOCKER_AVAILABLE%"=="1" goto choose_docker

goto choose_podman

:choose_docker
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Runtime requerido%RESET%
echo %BLUE%================================%RESET%
echo.
echo %YELLOW%[INFO]%RESET% No detectamos un runtime activo. Elige qué quieres arrancar:
echo.
echo   1) Docker
echo   q) Cancelar
echo.
choice /C 1Q /N /M "Selecciona una opción: "
if errorlevel 2 exit /b 1
set "SELECTED_RUNTIME=docker"
call :start_runtime
exit /b !errorlevel!

:choose_podman
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Runtime requerido%RESET%
echo %BLUE%================================%RESET%
echo.
echo %YELLOW%[INFO]%RESET% No detectamos un runtime activo. Elige qué quieres arrancar:
echo.
echo   1) Podman
echo   q) Cancelar
echo.
choice /C 1Q /N /M "Selecciona una opción: "
if errorlevel 2 exit /b 1
set "SELECTED_RUNTIME=podman"
call :start_runtime
exit /b !errorlevel!

:choose_runtime
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Runtime requerido%RESET%
echo %BLUE%================================%RESET%
echo.
echo %YELLOW%[INFO]%RESET% No detectamos un runtime activo. Elige cuál quieres arrancar:
echo.
echo   1) Docker
echo   2) Podman
echo   3) Cancelar
echo.
choice /C 123 /N /M "Selecciona una opción: "
if errorlevel 3 (
    exit /b 1
)
if errorlevel 2 (
    set "SELECTED_RUNTIME=podman"
)
if errorlevel 1 (
    set "SELECTED_RUNTIME=docker"
)

call :start_runtime
exit /b !errorlevel!

:start_runtime
if "%SELECTED_RUNTIME%"=="docker" goto start_docker
if "%SELECTED_RUNTIME%"=="podman" goto start_podman
echo %RED%[ERROR]%RESET% Runtime desconocido: %SELECTED_RUNTIME%
exit /b 1

:start_docker
echo %YELLOW%[INFO]%RESET% Preparando Docker...
if exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" (
    start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
) else if exist "%ProgramFiles(x86)%\Docker\Docker\Docker Desktop.exe" (
    start "" "%ProgramFiles(x86)%\Docker\Docker\Docker Desktop.exe"
) else (
    echo %YELLOW%[INFO]%RESET% Abre Docker Desktop manualmente si no se inicia automáticamente
)

call :wait_for_runtime docker
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Docker no respondió a tiempo
    echo %YELLOW%[INFO]%RESET% Vuelve a intentarlo después de abrir Docker Desktop
    exit /b 1
)

echo %GREEN%[OK]%RESET% Docker está listo
exit /b 0

:start_podman
echo %YELLOW%[INFO]%RESET% Preparando Podman...
podman machine start
if errorlevel 1 (
    echo %YELLOW%[INFO]%RESET% No se pudo arrancar Podman machine automáticamente
)

call :wait_for_runtime podman
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Podman no respondió a tiempo
    echo %YELLOW%[INFO]%RESET% Vuelve a intentarlo después de arrancar Podman
    exit /b 1
)

echo %GREEN%[OK]%RESET% Podman está listo
exit /b 0

:wait_for_runtime
set "RUNTIME_NAME=%~1"
set /a WAIT_COUNT=0

:wait_for_runtime_loop
if /I "%RUNTIME_NAME%"=="docker" (
    docker info >nul 2>&1 && exit /b 0
)

if /I "%RUNTIME_NAME%"=="podman" (
    podman info >nul 2>&1 && exit /b 0
)

if !WAIT_COUNT! GEQ 30 exit /b 1
timeout /t 2 /nobreak >nul
set /a WAIT_COUNT+=1
goto wait_for_runtime_loop

:stop_all
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Deteniendo servicios...%RESET%
echo %BLUE%================================%RESET%
echo.

taskkill /FI "WINDOWTITLE eq Kakebo*" /T /F 2>nul
timeout /t 2 /nobreak

echo %GREEN%[OK]%RESET% Servicios detenidos
echo.
exit /b 0

:restart_all
call :stop_all
timeout /t 2 /nobreak
goto start_all

:status
echo.
echo %BLUE%================================%RESET%
echo %BLUE%Estado de servicios%RESET%
echo %BLUE%================================%RESET%
echo.

netstat -ano | find ":9090" >nul
if %errorlevel%==0 (
    echo %GREEN%[OK]%RESET% Backend está corriendo en http://localhost:9090
) else (
    echo %RED%[ERROR]%RESET% Backend no está corriendo
)

netstat -ano | find ":5173" >nul
if %errorlevel%==0 (
    echo %GREEN%[OK]%RESET% Frontend está corriendo en http://localhost:5173
) else (
    echo %RED%[ERROR]%RESET% Frontend no está corriendo
)

echo.
exit /b 0

:help
cls
echo.
echo %BLUE%Kakebo Development Helper%RESET%
echo.
echo Uso: dev.bat [comando]
echo.
echo Comandos:
echo   %GREEN%start-backend%RESET%     Inicia solo el backend (Spring Boot)
echo   %GREEN%start-frontend%RESET%    Inicia solo el frontend (SvelteKit)
echo   %GREEN%start%RESET%             Inicia backend y frontend en nuevas ventanas
echo   %GREEN%stop%RESET%              Detiene todos los servicios
echo   %GREEN%restart%RESET%           Reinicia todos los servicios
echo   %GREEN%status%RESET%            Muestra el estado de los servicios
echo   %GREEN%help%RESET%              Muestra esta ayuda
echo.
echo Ejemplos:
echo   dev.bat start              # Inicia todo
echo   dev.bat start-backend      # Solo backend
echo   dev.bat status             # Ver qué está corriendo
echo.
echo %YELLOW%Notas:%RESET%
echo   - El primer inicio puede tardar más (descarga dependencias)
echo   - El arranque comprueba Docker/Podman y muestra un selector si hace falta
echo   - Frontend está en http://localhost:5173
echo   - Backend está en http://localhost:9090
echo   - Swagger en http://localhost:9090/swagger-ui.html
echo.
exit /b 0
