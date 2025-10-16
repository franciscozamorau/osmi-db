-- Tabla de tickets
CREATE TABLE IF NOT EXISTS tickets (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  public_id UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  transaction_id INTEGER REFERENCES transactions(id) ON DELETE SET NULL,
  event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  code VARCHAR(50) UNIQUE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'reserved', 'sold', 'used', 'cancelled', 'transferred')),
  seat_number VARCHAR(20),
  qr_code_url VARCHAR(512),
  price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
  used_at TIMESTAMP,
  transferred_from_ticket_id INTEGER REFERENCES tickets(id),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_tickets_code ON tickets(code);
CREATE INDEX IF NOT EXISTS idx_tickets_status ON tickets(status);
CREATE INDEX IF NOT EXISTS idx_tickets_event_id ON tickets(event_id);
CREATE INDEX IF NOT EXISTS idx_tickets_transaction_id ON tickets(transaction_id);
CREATE INDEX IF NOT EXISTS idx_tickets_category_id ON tickets(category_id);
CREATE INDEX IF NOT EXISTS idx_tickets_public_id ON tickets(public_id);

-- Comentario descriptivo
COMMENT ON TABLE tickets IS 'Tickets individuales con estado y códigos únicos';
COMMENT ON COLUMN tickets.public_id IS 'Identificador único para escaneo QR y APIs públicas';
