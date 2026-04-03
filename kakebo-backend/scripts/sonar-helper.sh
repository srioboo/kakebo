#!/bin/bash

# SonarQube Helper Script
# Facilita la instalación y gestión de SonarQube con Docker

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Configuration
SONAR_CONTAINER_NAME="kakebo-sonarqube"
SONAR_IMAGE="sonarqube:lts-community"
SONAR_PORT="9000"
SONAR_HOST="http://localhost:${SONAR_PORT}"
SONAR_ADMIN_USER="admin"
SONAR_ADMIN_PASS="admin"

# Function to display help
function show_help() {
  echo -e "${BLUE}SonarQube Management Script${NC}"
  echo ""
  echo -e "${YELLOW}Usage: ./scripts/sonar-helper.sh [command]${NC}"
  echo ""
  echo -e "${YELLOW}Commands:${NC}"
  echo -e "  ${GREEN}install${NC}      - Install SonarQube using Docker"
  echo -e "  ${GREEN}start${NC}        - Start SonarQube container"
  echo -e "  ${GREEN}stop${NC}         - Stop SonarQube container"
  echo -e "  ${GREEN}status${NC}       - Show container status"
  echo -e "  ${GREEN}logs${NC}         - Show container logs"
  echo -e "  ${GREEN}clean${NC}        - Remove SonarQube container and volumes"
  echo -e "  ${GREEN}token${NC}        - Generate SonarQube authentication token"
  echo -e "  ${GREEN}help${NC}         - Show this help message"
  echo ""
  echo -e "${CYAN}Examples:${NC}"
  echo -e "  ./scripts/sonar-helper.sh install   # Install SonarQube"
  echo -e "  ./scripts/sonar-helper.sh start     # Start SonarQube"
  echo -e "  ./scripts/sonar-helper.sh status    # Check if running"
  echo -e "  ./scripts/sonar-helper.sh token     # Generate token"
}

# Function to check if Docker is installed
function check_docker() {
  if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo -e "${YELLOW}Please install Docker from: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
  fi
  echo -e "${GREEN}✅ Docker is installed${NC}"
}

# Function to install SonarQube
function install_sonarqube() {
  echo -e "${BLUE}Installing SonarQube...${NC}"
  check_docker

  # Check if container already exists
  if docker ps -a --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
    echo -e "${YELLOW}⚠️  Container ${SONAR_CONTAINER_NAME} already exists${NC}"
    echo -e "${YELLOW}Removing old container...${NC}"
    docker rm -f "${SONAR_CONTAINER_NAME}" > /dev/null 2>&1
  fi

  echo -e "${YELLOW}Pulling SonarQube image (${SONAR_IMAGE})...${NC}"
  docker pull "${SONAR_IMAGE}"

  echo -e "${YELLOW}Creating SonarQube container...${NC}"
  docker run -d \
    --name "${SONAR_CONTAINER_NAME}" \
    -p "${SONAR_PORT}":9000 \
    -e SONAR_JDBC_URL=jdbc:h2:./data/h2 \
    -e SONAR_JDBC_DRIVER=org.h2.Driver \
    -v "${SONAR_CONTAINER_NAME}_logs":/opt/sonarqube/logs \
    -v "${SONAR_CONTAINER_NAME}_data":/opt/sonarqube/data \
    -v "${SONAR_CONTAINER_NAME}_extensions":/opt/sonarqube/extensions \
    "${SONAR_IMAGE}"

  echo -e "${YELLOW}Waiting for SonarQube to start (this may take 30-60 seconds)...${NC}"

  # Wait for SonarQube to be ready
  local max_attempts=60
  local attempt=0

  while [ $attempt -lt $max_attempts ]; do
    if curl -s "${SONAR_HOST}/api/system/health" > /dev/null 2>&1; then
      echo -e "${GREEN}✅ SonarQube is running!${NC}"
      break
    fi
    echo -n "."
    sleep 1
    ((attempt++))
  done

  if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}❌ SonarQube failed to start${NC}"
    echo -e "${YELLOW}Check logs: ./scripts/sonar-helper.sh logs${NC}"
    exit 1
  fi

  echo ""
  echo -e "${GREEN}✅ Installation complete!${NC}"
  echo ""
  echo -e "${CYAN}Next steps:${NC}"
  echo -e "  1. Open: ${SONAR_HOST}"
  echo -e "  2. Login with: ${SONAR_ADMIN_USER} / ${SONAR_ADMIN_PASS}"
  echo -e "  3. Create a token: ./scripts/sonar-helper.sh token"
  echo -e "  4. Run analysis: ./scripts/manage.sh sonar"
}

# Function to start SonarQube
function start_sonarqube() {
  echo -e "${BLUE}Starting SonarQube...${NC}"
  check_docker

  if docker ps --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
    echo -e "${YELLOW}⚠️  SonarQube is already running${NC}"
    return 0
  fi

  if ! docker ps -a --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
    echo -e "${RED}❌ Container not found. Please run: ./scripts/sonar-helper.sh install${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Starting container...${NC}"
  docker start "${SONAR_CONTAINER_NAME}"

  echo -e "${YELLOW}Waiting for SonarQube to be ready...${NC}"
  sleep 5

  echo -e "${GREEN}✅ SonarQube started!${NC}"
  echo -e "${CYAN}Access at: ${SONAR_HOST}${NC}"
}

# Function to stop SonarQube
function stop_sonarqube() {
  echo -e "${BLUE}Stopping SonarQube...${NC}"
  check_docker

  if ! docker ps --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
    echo -e "${YELLOW}⚠️  SonarQube is not running${NC}"
    return 0
  fi

  docker stop "${SONAR_CONTAINER_NAME}"
  echo -e "${GREEN}✅ SonarQube stopped${NC}"
}

# Function to show container status
function show_status() {
  echo -e "${BLUE}SonarQube Status:${NC}"
  check_docker

  if docker ps --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
    echo -e "${GREEN}✅ Running${NC}"
    echo -e "${CYAN}Access at: ${SONAR_HOST}${NC}"

    # Show resource usage
    echo ""
    echo -e "${YELLOW}Container Info:${NC}"
    docker ps --filter "name=${SONAR_CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
  else
    echo -e "${YELLOW}⚠️  Not running${NC}"

    if docker ps -a --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
      echo -e "${CYAN}To start: ./scripts/sonar-helper.sh start${NC}"
    else
      echo -e "${CYAN}To install: ./scripts/sonar-helper.sh install${NC}"
    fi
  fi
}

# Function to show logs
function show_logs() {
  echo -e "${BLUE}SonarQube Logs:${NC}"
  check_docker

  if ! docker ps -a --format '{{.Names}}' | grep -q "^${SONAR_CONTAINER_NAME}$"; then
    echo -e "${RED}❌ Container not found${NC}"
    exit 1
  fi

  docker logs -f "${SONAR_CONTAINER_NAME}"
}

# Function to clean up
function clean_sonarqube() {
  echo -e "${RED}⚠️  This will remove SonarQube container and all data!${NC}"
  echo -n "Are you sure? (y/N) "
  read -r response

  if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo -e "${YELLOW}Cancelled${NC}"
    return 0
  fi

  echo -e "${BLUE}Removing SonarQube...${NC}"
  check_docker

  docker stop "${SONAR_CONTAINER_NAME}" 2>/dev/null || true
  docker rm "${SONAR_CONTAINER_NAME}" 2>/dev/null || true
  docker volume rm "${SONAR_CONTAINER_NAME}_logs" 2>/dev/null || true
  docker volume rm "${SONAR_CONTAINER_NAME}_data" 2>/dev/null || true
  docker volume rm "${SONAR_CONTAINER_NAME}_extensions" 2>/dev/null || true

  echo -e "${GREEN}✅ SonarQube removed${NC}"
}

# Function to generate token
function generate_token() {
  echo -e "${BLUE}Generating SonarQube Token...${NC}"
  echo ""
  echo -e "${YELLOW}This will open SonarQube in your browser to generate a token${NC}"
  echo -e "${YELLOW}Steps:${NC}"
  echo "  1. Login with: admin / admin"
  echo "  2. Click on your avatar (top right)"
  echo "  3. Select 'My Account'"
  echo "  4. Click 'Security' tab"
  echo "  5. Under 'Generate Tokens', enter a name (e.g., 'kakebo-token')"
  echo "  6. Click 'Generate'"
  echo "  7. Copy the token"
  echo ""
  echo -e "${CYAN}Opening SonarQube...${NC}"

  # Try to open in default browser
  if command -v open &> /dev/null; then
    open "${SONAR_HOST}/account/security"
  elif command -v xdg-open &> /dev/null; then
    xdg-open "${SONAR_HOST}/account/security"
  else
    echo -e "${YELLOW}Please open manually: ${SONAR_HOST}/account/security${NC}"
  fi

  echo ""
  echo -e "${CYAN}After generating the token, use it:${NC}"
  echo "  export SONAR_LOGIN=<your-token>"
  echo "  ./scripts/manage.sh sonar"
}

# Main script logic
case "$1" in
  install)
    install_sonarqube
    ;;
  start)
    start_sonarqube
    ;;
  stop)
    stop_sonarqube
    ;;
  status)
    show_status
    ;;
  logs)
    show_logs
    ;;
  clean)
    clean_sonarqube
    ;;
  token)
    generate_token
    ;;
  help|*)
    show_help
    ;;
esac

