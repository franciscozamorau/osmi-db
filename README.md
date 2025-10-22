# osmi-db

osmi-db es el módulo responsable de la definición, migración y mantenimiento estructural de la base de datos del ecosistema osmi. Centraliza toda la lógica SQL en archivos independientes, desacoplando completamente la gestión de esquema del servidor de aplicación (osmi-server) y del gateway (osmi-gateway).
---

# Estructura del módulo

```bash
osmi-db/
├── cmd/
│   └── migrate.go            # Ejecuta las migraciones
├── internal/
│   ├── sql/
│   │   ├── 01_extensions.sql
│   │   ├── 02_users.sql
│   │   ├── 03_customers.sql
│   │   ├── 04_events.sql
│   │   ├── 05_categories.sql
│   │   ├── 06_tickets.sql
│   │   ├── 07_transactions.sql
│   │   ├── 08_promotions.sql
│   │   ├── 09_audit.sql
│   │   ├── 10_triggers.sql
│   │   └── 11_views.sql
│   └── migrator/
│       └── migrator.go       # Lógica para ejecutar los archivos SQL
├── go.mod
├── go.sum
└── LICENSE.md
└── README.md
```

## Funcionalidad
Ejecuta migraciones SQL en orden alfabético desde internal/sql/
Cada archivo .sql representa una unidad modular: extensiones, tablas, índices, triggers, vistas
No contiene lógica de aplicación ni datos embebidos en Go
Compatible con pgxpool y PostgreSQL ≥ 14
---

## Ejecución de migraciones

** Requisitos **
Go ≥ 1.20
PostgreSQL corriendo y accesible
Variable de entorno DATABASE_URL configurada (opcional)
---

## Comando
```bash
go run cmd/migrate.go
```
## Valor por defecto si no se define DATABASE_URL:

```bash
postgres://osmi:osmi1405@localhost:5432/osmidb
```

# Migraciones incluidas

Archivo	Descripción técnica

01_extensions.sql	Activación de extensiones PostgreSQL
02_users.sql	Tabla de usuarios con roles y autenticación
03_customers.sql	Clientes extendidos con preferencias y verificación
04_events.sql	Eventos con ubicación, fechas y estado
05_categories.sql	Categorías de tickets con control de disponibilidad
06_tickets.sql	Tickets individuales con estado, código y QR
07_transactions.sql	Transacciones con integración Stripe
08_promotions.sql	Promociones con reglas de descuento
09_audit.sql	Auditoría de clientes, tickets y transacciones
10_triggers.sql	Triggers para updated_at, auditoría y control de stock
11_views.sql	Vistas para reportes de ventas y detalles de tickets
---

## Buenas prácticas
No modificar archivos .sql en caliente
Versionar cambios estructurales como nuevos archivos
No incluir lógica de negocio ni datos de prueba
Toda modificación debe ejecutarse vía main.go
---

## Propósito del módulo
Este módulo garantiza:
Separación absoluta entre lógica de aplicación y estructura de base.
Migraciones trazables, reversibles y auditables.
Legado técnico claro, modular y profesional.
---

# Autor

Francisco David Zamora Urrutia — Fullstack Developer & Systems Engineer