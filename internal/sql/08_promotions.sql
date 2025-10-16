-- Tabla de promociones y descuentos
CREATE TABLE IF NOT EXISTS promotions (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  public_id UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  code VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
  discount_value DECIMAL(10,2) NOT NULL CHECK (discount_value >= 0),
  event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
  min_order_amount DECIMAL(10,2) CHECK (min_order_amount >= 0),
  max_discount_amount DECIMAL(10,2) CHECK (max_discount_amount >= 0),
  valid_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  valid_to TIMESTAMP NOT NULL,
  usage_limit INTEGER CHECK (usage_limit >= 0),
  usage_count INTEGER NOT NULL DEFAULT 0 CHECK (usage_count >= 0),
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CHECK (valid_to > valid_from),
  CHECK (usage_count <= usage_limit OR usage_limit IS NULL)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_promotions_code ON promotions(code);
CREATE INDEX IF NOT EXISTS idx_promotions_event_id ON promotions(event_id);
CREATE INDEX IF NOT EXISTS idx_promotions_valid_to ON promotions(valid_to);
CREATE INDEX IF NOT EXISTS idx_promotions_is_active ON promotions(is_active);
