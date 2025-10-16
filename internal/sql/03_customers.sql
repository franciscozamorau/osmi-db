-- Tabla de clientes extendidos
CREATE TABLE IF NOT EXISTS customers (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  public_id UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  date_of_birth DATE,
  address JSONB,
  preferences JSONB,
  loyalty_points INTEGER DEFAULT 0,
  is_verified BOOLEAN NOT NULL DEFAULT false,
  verification_token VARCHAR(100),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices optimizados
CREATE UNIQUE INDEX IF NOT EXISTS idx_customers_email ON customers(email) WHERE is_verified = true;
CREATE INDEX IF NOT EXISTS idx_customers_name_trgm ON customers USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_user_id ON customers(user_id);

-- Comentario descriptivo
COMMENT ON TABLE customers IS 'Información extendida de clientes con preferencias y datos de contacto';
