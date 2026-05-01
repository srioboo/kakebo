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
echo   - Frontend está en http://localhost:5173
echo   - Backend está en http://localhost:9090
echo   - Swagger en http://localhost:9090/swagger-ui.html
echo.
exit /b 0
