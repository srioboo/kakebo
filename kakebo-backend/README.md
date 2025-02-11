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

