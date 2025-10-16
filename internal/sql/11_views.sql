-- Vista para reportes de ventas
CREATE OR REPLACE VIEW sales_report AS
SELECT 
  e.public_id as event_id,
  e.name as event_name,
  c.public_id as category_id,
  c.name as category_name,
  c.price,
  c.quantity_available,
  c.quantity_sold,
  c.quantity_available - c.quantity_sold as remaining_tickets,
  ROUND((c.quantity_sold::DECIMAL / GREATEST(c.quantity_available, 1)) * 100, 2) as sold_percentage,
  c.quantity_sold * c.price as total_revenue
FROM categories c
JOIN events e ON c.event_id = e.id
WHERE e.is_active = true AND c.is_active = true;

-- Vista para tickets con información completa
CREATE OR REPLACE VIEW ticket_details AS
SELECT 
  t.public_id as ticket_id,
  t.code,
  t.status,
  t.seat_number,
  t.price,
  t.created_at,
  c.public_id as category_id,
  c.name as category_name,
  e.public_id as event_id,
  e.name as event_name,
  e.start_date,
  e.location,
  cust.public_id as customer_id,
  cust.name as customer_name,
  cust.email as customer_email,
  trans.public_id as transaction_id,
  trans.status as transaction_status
FROM tickets t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN events e ON t.event_id = e.id
LEFT JOIN transactions trans ON t.transaction_id = trans.id
LEFT JOIN customers cust ON trans.customer_id = cust.id;
