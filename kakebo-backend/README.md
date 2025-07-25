# Kakebo Backend

Kakebo personal finances proyect backend

## Arquitecture

Hexagonal arquitecture

```shell
src
├── main
│  ├── java
│  │  └── org
│  │     └── sirantar
│  │        └── kakebo
│  │           └── KakeboApplication.java
│  └── resources
│     ├── application.properties
│     ├── db
│     │  └── migration
│     ├── static
│     └── templates
├── Main.java
└── test
└── java
└── org
└── sirantar
└── kakebo
├── gastos
├── ingresos
└── KakeboApplicationTests.java
```

## Troubleshooting

1. Docker give an error, test that docker is woring
    - also test that the 8080 port it not in use
2. Complains about gradle version with jdk 22, gradle not works con 22, use 21

## Gradle

Change from gradle to maven, only becoause is esasiest for me to mantain, I will conserve here de files

build.gradle.kts

```kotlin
plugins {
	id("java")
	id("org.springframework.boot") version "3.3.0"
	id("io.spring.dependency-management") version "1.1.5"
}

group = "org.sirantar.kakebo"
version = "0.0.1-SNAPSHOT"

// java {
	// toolchain {
		// languageVersion = JavaLanguageVersion.of(21)
	// }
// }

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-web")
	developmentOnly("org.springframework.boot:spring-boot-docker-compose")
	implementation("org.flywaydb:flyway-database-postgresql:10.20.1")  // Dependencia de Flyway
	runtimeOnly("org.postgresql:postgresql")
	runtimeOnly("org.springframework.boot:spring-boot-devtools")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
	// https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-starter-webmvc-ui - swagger
	implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.1.0")
}

tasks.test {
	useJUnitPlatform()
	testLogging {
		events("passed", "skipped", "failed")
	}
}
```

settings.gradle.kts

```kotlin
rootProject.name = "kakebo-backend"
```