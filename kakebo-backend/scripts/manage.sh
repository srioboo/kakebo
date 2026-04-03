#!/bin/bash

# Unified script to manage the Spring Boot application
# Usage:
#   ./manage.sh [command]
#
# Commands:
#   start   - Start the application
#   stop    - Stop the application
#   build   - Build the project
#   test    - Run tests
#   help    - Show this help message

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Function to display help
function show_help() {
  echo -e "${BLUE}Usage: ./manage.sh [command]${NC}"
  echo ""
  echo -e "${YELLOW}Commands:${NC}"
  echo -e "  ${GREEN}start${NC}         - Start the application"
  echo -e "  ${GREEN}stop${NC}          - Stop the application"
  echo -e "  ${GREEN}build${NC}         - Build the project"
  echo -e "  ${GREEN}test${NC}          - Run tests"
  echo -e "  ${GREEN}lint${NC}          - Run SonarQube analysis (replaces checkstyle + pmd)"
  echo -e "  ${GREEN}sonar${NC}         - Run SonarQube analysis"
  echo -e "  ${GREEN}sonar-local${NC}   - Run SonarQube analysis locally (no server needed)"
  echo -e "  ${GREEN}coverage${NC}      - Generate code coverage reports"
  echo -e "  ${GREEN}help${NC}          - Show this help message"
}

# Function to start the application
function start_application() {
  echo -e "${BLUE}Starting the application...${NC}"
  ./mvnw spring-boot:run
}

# Function to stop the application
function stop_application() {
  echo -e "${RED}Stopping the application...${NC}"
  pkill -f 'spring-boot:run'
}

# Function to build the project
function build_project() {
  echo -e "${YELLOW}Building the project...${NC}"
  ./mvnw package
}

# Function to run tests
function run_tests() {
  echo -e "${GREEN}Running tests...${NC}"
  ./mvnw test
}

# Function to run SonarQube analysis
function run_sonar() {
  echo -e "${YELLOW}Running SonarQube analysis...${NC}"
  echo -e "${BLUE}Note: This requires a SonarQube server running.${NC}"
  echo -e "${BLUE}Configure SONAR_HOST_URL and SONAR_LOGIN in environment or sonar-project.properties${NC}"

  if [ -z "$SONAR_HOST_URL" ]; then
    echo -e "${YELLOW}SONAR_HOST_URL not set. Using default: http://localhost:9000${NC}"
    SONAR_HOST_URL="http://localhost:9000"
  fi

  ./mvnw clean verify sonar:sonar \
    -Dsonar.host.url="$SONAR_HOST_URL" \
    -Dsonar.login="$SONAR_LOGIN"
}

# Function to run SonarQube analysis locally (without server)
function run_sonar_local() {
  echo -e "${YELLOW}Running local SonarQube analysis...${NC}"
  echo -e "${BLUE}Generating report without SonarQube server connection${NC}"

  ./mvnw clean verify \
    -Dsonar.analysis.mode=publish \
    -Dsonar.projectKey=kakebo-backend
}

# Function to generate code coverage reports
function run_coverage() {
  echo -e "${YELLOW}Generating code coverage reports...${NC}"
  ./mvnw clean test jacoco:report
  echo -e "${GREEN}Coverage report generated in: target/site/jacoco/index.html${NC}"
}

# Function to run all linting checks
function run_lint() {
  echo -e "${BLUE}Running all quality checks with SonarQube...${NC}"
  run_sonar_local
  echo ""
  run_coverage
  echo -e "${GREEN}Quality checks completed!${NC}"
}

# Main script logic
case "$1" in
  start)
    start_application
    ;;
  stop)
    stop_application
    ;;
  build)
    build_project
    ;;
  test)
    run_tests
    ;;
  lint)
    run_lint
    ;;
  sonar)
    run_sonar
    ;;
  sonar-local)
    run_sonar_local
    ;;
  coverage)
    run_coverage
    ;;
  help|*)
    show_help
    ;;
esac