-- Auditoría de clientes
CREATE TABLE IF NOT EXISTS customer_audit (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  public_id UUID NOT NULL,
  operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  changed_by VARCHAR(100) NOT NULL DEFAULT current_user,
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  old_data JSONB,
  new_data JSONB,
  ip_address INET,
  user_agent TEXT
);

CREATE INDEX IF NOT EXISTS idx_customer_audit_customer_id ON customer_audit(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_audit_changed_at ON customer_audit(changed_at);
CREATE INDEX IF NOT EXISTS idx_customer_audit_operation ON customer_audit(operation);

-- Auditoría de transacciones
CREATE TABLE IF NOT EXISTS transaction_audit (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transaction_id INTEGER NOT NULL,
  public_id UUID NOT NULL,
  operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  changed_by VARCHAR(100) NOT NULL DEFAULT current_user,
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  old_data JSONB,
  new_data JSONB,
  ip_address INET
);

CREATE INDEX IF NOT EXISTS idx_transaction_audit_transaction_id ON transaction_audit(transaction_id);
CREATE INDEX IF NOT EXISTS idx_transaction_audit_changed_at ON transaction_audit(changed_at);

-- Auditoría de tickets
CREATE TABLE IF NOT EXISTS ticket_audit (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ticket_id INTEGER NOT NULL,
  public_id UUID NOT NULL,
  operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  changed_by VARCHAR(100) NOT NULL DEFAULT current_user,
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  old_data JSONB,
  new_data JSONB
);

CREATE INDEX IF NOT EXISTS idx_ticket_audit_ticket_id ON ticket_audit(ticket_id);
CREATE INDEX IF NOT EXISTS idx_ticket_audit_changed_at ON ticket_audit(changed_at);
