-- =====================================================
-- 03_queries.sql
-- Query utili con JOIN, GROUP BY e sottoquery
-- =====================================================

-- 1. Elenco ordini con dati utente
SELECT o.order_id,
       u.first_name,
       u.last_name,
       u.email,
       o.order_date,
       o.status,
       o.total_amount
FROM orders o
JOIN users u ON u.user_id = o.user_id
ORDER BY o.order_date DESC;

-- 2. Dettaglio righe ordine con nome prodotto
SELECT oi.order_item_id,
       oi.order_id,
       p.name AS product_name,
       oi.quantity,
       oi.unit_price,
       oi.line_total
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
ORDER BY oi.order_id, product_name;

-- 3. Totale speso per utente (solo ordini pagati o spediti)
SELECT u.user_id,
       u.first_name,
       u.last_name,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM users u
LEFT JOIN orders o
       ON o.user_id = u.user_id
      AND o.status IN ('paid', 'shipped')
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_spent DESC;

-- 4. Top prodotti più venduti per quantità
SELECT p.product_id,
       p.name,
       SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o   ON o.order_id = oi.order_id
WHERE o.status IN ('paid', 'shipped')
GROUP BY p.product_id, p.name
ORDER BY total_units_sold DESC, p.name;

-- 5. Fatturato per categoria
SELECT c.name AS category_name,
       ROUND(SUM(oi.line_total), 2) AS revenue
FROM order_items oi
JOIN products p   ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
JOIN orders o     ON o.order_id = oi.order_id
WHERE o.status IN ('paid', 'shipped')
GROUP BY c.name
ORDER BY revenue DESC;

-- 6. Utenti che non hanno mai fatto ordini
SELECT u.user_id,
       u.first_name,
       u.last_name,
       u.email
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id
WHERE o.order_id IS NULL;

-- 7. Ordini effettuati in un intervallo di date con nome utente
SELECT o.order_id,
       CONCAT(u.first_name, ' ', u.last_name) AS customer,
       o.order_date,
       o.status,
       o.total_amount
FROM orders o
JOIN users u ON u.user_id = o.user_id
WHERE o.order_date BETWEEN '2026-03-01' AND '2026-03-08'
ORDER BY o.order_date;

-- 8. Valore medio ordine per utente
SELECT u.user_id,
       CONCAT(u.first_name, ' ', u.last_name) AS customer,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM users u
JOIN orders o ON o.user_id = u.user_id
WHERE o.status IN ('paid', 'shipped', 'pending')
GROUP BY u.user_id, customer
ORDER BY avg_order_value DESC;

-- 9. Prodotti mai ordinati
SELECT p.product_id,
       p.name,
       p.sku
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;

-- 10. Totale righe ordine ricalcolato e confronto con total_amount
SELECT o.order_id,
       o.total_amount AS stored_total,
       COALESCE(SUM(oi.line_total), 0) AS calculated_total,
       (o.total_amount - COALESCE(SUM(oi.line_total), 0)) AS difference
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
ORDER BY o.order_id;
