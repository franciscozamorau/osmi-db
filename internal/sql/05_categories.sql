-- Tabla de categorías de tickets
CREATE TABLE IF NOT EXISTS categories (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  public_id UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
  quantity_available INTEGER NOT NULL CHECK (quantity_available >= 0),
  quantity_sold INTEGER NOT NULL DEFAULT 0 CHECK (quantity_sold >= 0),
  max_tickets_per_order INTEGER NOT NULL DEFAULT 10 CHECK (max_tickets_per_order > 0),
  sales_start TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sales_end TIMESTAMP,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CHECK (quantity_sold <= quantity_available),
  CHECK (sales_end IS NULL OR sales_end > sales_start)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_categories_event_id ON categories(event_id);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);
CREATE INDEX IF NOT EXISTS idx_categories_sales_end ON categories(sales_end);

-- Comentario descriptivo
COMMENT ON TABLE categories IS 'Categorías de tickets con precios y disponibilidad';
