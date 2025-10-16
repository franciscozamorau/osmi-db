-- Función para actualizar automáticamente updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger de updated_at a todas las tablas principales
CREATE OR REPLACE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_customers_updated_at
BEFORE UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_events_updated_at
BEFORE UPDATE ON events
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_promotions_updated_at
BEFORE UPDATE ON promotions
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_transactions_updated_at
BEFORE UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_tickets_updated_at
BEFORE UPDATE ON tickets
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para actualizar quantity_sold en categories
CREATE OR REPLACE FUNCTION update_ticket_sold_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' AND NEW.status = 'sold' THEN
    UPDATE categories 
    SET quantity_sold = quantity_sold + 1 
    WHERE id = NEW.category_id;
  ELSIF TG_OP = 'UPDATE' THEN
    IF OLD.status != 'sold' AND NEW.status = 'sold' THEN
      UPDATE categories 
      SET quantity_sold = quantity_sold + 1 
      WHERE id = NEW.category_id;
    ELSIF OLD.status = 'sold' AND NEW.status != 'sold' THEN
      UPDATE categories 
      SET quantity_sold = quantity_sold - 1 
      WHERE id = NEW.category_id;
    END IF;
  ELSIF TG_OP = 'DELETE' AND OLD.status = 'sold' THEN
    UPDATE categories 
    SET quantity_sold = quantity_sold - 1 
    WHERE id = OLD.category_id;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_ticket_sold_count
AFTER INSERT OR UPDATE OR DELETE ON tickets
FOR EACH ROW EXECUTE FUNCTION update_ticket_sold_count();

-- Función para validar disponibilidad de tickets
CREATE OR REPLACE FUNCTION validate_ticket_availability()
RETURNS TRIGGER AS $$
DECLARE
  available_count INTEGER;
BEGIN
  SELECT quantity_available - quantity_sold INTO available_count
  FROM categories WHERE id = NEW.category_id;

  IF available_count <= 0 THEN
    RAISE EXCEPTION 'No hay tickets disponibles para esta categoría';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validate_ticket_availability
BEFORE INSERT ON tickets
FOR EACH ROW EXECUTE FUNCTION validate_ticket_availability();

-- Funciones de auditoría
CREATE OR REPLACE FUNCTION audit_customer_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO customer_audit (customer_id, public_id, operation, new_data)
    VALUES (NEW.id, NEW.public_id, TG_OP, to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO customer_audit (customer_id, public_id, operation, old_data, new_data)
    VALUES (NEW.id, NEW.public_id, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO customer_audit (customer_id, public_id, operation, old_data)
    VALUES (OLD.id, OLD.public_id, TG_OP, to_jsonb(OLD));
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER trigger_audit_customer
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION audit_customer_changes();

CREATE OR REPLACE FUNCTION audit_ticket_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO ticket_audit (ticket_id, public_id, operation, new_data)
    VALUES (NEW.id, NEW.public_id, TG_OP, to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO ticket_audit (ticket_id, public_id, operation, old_data, new_data)
    VALUES (NEW.id, NEW.public_id, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO ticket_audit (ticket_id, public_id, operation, old_data)
    VALUES (OLD.id, OLD.public_id, TG_OP, to_jsonb(OLD));
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER trigger_audit_ticket
AFTER INSERT OR UPDATE OR DELETE ON tickets
FOR EACH ROW EXECUTE FUNCTION audit_ticket_changes();
