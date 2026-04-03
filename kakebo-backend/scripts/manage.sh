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
  echo -e "  ${GREEN}start${NC}   - Start the application"
  echo -e "  ${GREEN}stop${NC}    - Stop the application"
  echo -e "  ${GREEN}build${NC}   - Build the project"
  echo -e "  ${GREEN}test${NC}    - Run tests"
  echo -e "  ${GREEN}help${NC}    - Show this help message"
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
  help|*)
    show_help
    ;;
esac