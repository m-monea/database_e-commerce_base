-- =====================================================
-- 02_seed.sql
-- Dati di esempio
-- =====================================================

INSERT INTO users (first_name, last_name, email, phone) VALUES
('Luca', 'Rossi', 'luca.rossi@email.com', '+39 333 1111111'),
('Giulia', 'Bianchi', 'giulia.bianchi@email.com', '+39 333 2222222'),
('Marco', 'Verdi', 'marco.verdi@email.com', '+39 333 3333333'),
('Elena', 'Neri', 'elena.neri@email.com', '+39 333 4444444'),
('Sara', 'Gallo', 'sara.gallo@email.com', '+39 333 5555555');

INSERT INTO categories (name, description) VALUES
('Libri', 'Romanzi, saggi e manuali'),
('Informatica', 'Accessori e dispositivi tech'),
('Cancelleria', 'Prodotti per studio e ufficio');

INSERT INTO products (category_id, sku, name, description, price, stock, is_active) VALUES
(1, 'LIB-001', 'Clean Code', 'Libro di programmazione', 32.50, 25, TRUE),
(1, 'LIB-002', 'Database Design', 'Manuale di progettazione database', 28.90, 18, TRUE),
(1, 'LIB-003', 'Algoritmi Moderni', 'Testo avanzato di algoritmi', 41.00, 10, TRUE),
(2, 'INF-001', 'Mouse Wireless', 'Mouse ergonomico', 19.99, 40, TRUE),
(2, 'INF-002', 'Tastiera Meccanica', 'Tastiera per sviluppo e gaming', 79.90, 12, TRUE),
(2, 'INF-003', 'SSD 1TB', 'Unità di archiviazione veloce', 89.00, 15, TRUE),
(3, 'CAN-001', 'Quaderno A4', 'Quaderno a righe', 3.20, 100, TRUE),
(3, 'CAN-002', 'Penna Gel Blu', 'Penna a inchiostro gel', 1.80, 250, TRUE);

INSERT INTO orders (user_id, order_date, status, total_amount) VALUES
(1, '2026-03-01 10:30:00', 'paid', 72.48),
(2, '2026-03-02 14:10:00', 'shipped', 83.10),
(1, '2026-03-05 09:00:00', 'pending', 89.00),
(3, '2026-03-07 18:45:00', 'paid', 38.30),
(4, '2026-03-10 11:20:00', 'cancelled', 32.50);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 32.50),
(1, 4, 2, 19.99),
(2, 2, 1, 28.90),
(2, 7, 5, 3.20),
(2, 8, 5, 1.80),
(2, 4, 1, 19.99),
(3, 6, 1, 89.00),
(4, 7, 10, 3.20),
(4, 8, 3, 1.80),
(5, 1, 1, 32.50);
