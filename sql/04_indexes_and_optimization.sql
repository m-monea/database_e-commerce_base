-- =====================================================
-- 04_indexes_and_optimization.sql
-- Indici e note di ottimizzazione
-- =====================================================

-- Indici sulle foreign key
CREATE INDEX IF NOT EXISTS idx_products_category_id
    ON products(category_id);

CREATE INDEX IF NOT EXISTS idx_orders_user_id
    ON orders(user_id);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);

-- Indici utili per filtri frequenti
CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders(status);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_products_is_active
    ON products(is_active);

-- Indice composito utile per query tipiche su utente + stato + data
CREATE INDEX IF NOT EXISTS idx_orders_user_status_date
    ON orders(user_id, status, order_date DESC);
