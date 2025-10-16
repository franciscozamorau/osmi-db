package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"osmi-db/migrator"

	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
	// Obtener cadena de conexión desde variable de entorno
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		dsn = "postgres://osmi:osmi1405@localhost:5432/osmidb"
	}

	// Contexto con timeout para conexión
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Crear pool de conexiones
	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		log.Fatalf("Error al conectar a la base de datos: %v", err)
	}
	defer pool.Close()

	// Ejecutar migraciones desde carpeta sql
	err = migrator.RunMigrations(ctx, pool, "internal/sql")
	if err != nil {
		log.Fatalf("Error en migraciones: %v", err)
	}

	fmt.Println("Migraciones ejecutadas correctamente")
}
