.PHONY: start stop test build lint sonar sonar-local coverage help

# Start the Spring Boot application
start:
	./scripts/manage.sh start

# Stop the Spring Boot application
stop:
	./scripts/manage.sh stop

# Run tests for the project
test:
	./scripts/manage.sh test

# Build the project
build:
	./scripts/manage.sh build

# Run all quality checks (SonarQube local + coverage)
lint:
	./scripts/manage.sh lint

# Run SonarQube analysis (requires SonarQube server)
sonar:
	./scripts/manage.sh sonar

# Run local SonarQube analysis (no server needed)
sonar-local:
	./scripts/manage.sh sonar-local

# Generate code coverage reports
coverage:
	./scripts/manage.sh coverage

# Display help
help:
	./scripts/manage.sh help
