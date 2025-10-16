package migrator

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/jackc/pgx/v5/pgxpool"
)

func RunMigrations(ctx context.Context, pool *pgxpool.Pool, sqlDir string) error {
	entries, err := os.ReadDir(sqlDir)
	if err != nil {
		return fmt.Errorf("error leyendo carpeta de migraciones: %w", err)
	}

	var files []string
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".sql") {
			continue
		}
		files = append(files, entry.Name())
	}

	sort.Strings(files)

	for _, filename := range files {
		path := filepath.Join(sqlDir, filename)
		content, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("error leyendo archivo %s: %w", path, err)
		}

		log.Printf("Ejecutando migración: %s", filename)
		_, err = pool.Exec(ctx, string(content))
		if err != nil {
			return fmt.Errorf("error ejecutando %s: %w", filename, err)
		}
	}

	log.Printf("Migraciones ejecutadas: %d archivos", len(files))
	return nil
}
