package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/franciscozamorau/osmi-db/internal/db"
	"github.com/franciscozamorau/osmi-db/migrator"
)

func main() {
	// Inicializar conexión a la base de datos
	if err := db.Init(); err != nil {
		log.Fatalf("Error inicializando DB: %v", err)
	}
	defer db.Close()

	// Contexto con timeout para migraciones
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Ejecutar migraciones desde carpeta sql
	if err := migrator.RunMigrations(ctx, db.Pool, "./internal/sql"); err != nil {
		log.Fatalf("Error ejecutando migraciones: %v", err)
	}

	fmt.Println("Migraciones ejecutadas correctamente")
}
