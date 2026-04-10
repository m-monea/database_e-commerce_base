# Progetto Database - E-commerce Base
Un progetto SQL pensato per mostrare progettazione.

## Obiettivo
Realizzare un database relazionale per un e-commerce base con:
- più tabelle collegate tra loro
- vincoli di integrità
- query con `JOIN`
- query ottimizzate
- indici per migliorare le prestazioni

## Stack
- **Database target:** PostgreSQL 15+
- **Linguaggio:** SQL

> Le query usano sintassi PostgreSQL moderna, ma la struttura è facilmente adattabile ad altri RDBMS.

---

## Struttura del progetto

```text
progetto-database-serio/
├── README.md
├── docs/
│   └── schema.md
└── sql/
    ├── 01_schema.sql
    ├── 02_seed.sql
    ├── 03_queries.sql
    └── 04_indexes_and_optimization.sql
```

---

## Modello dati

Le entità principali sono:

- **users**: utenti registrati
- **categories**: categorie prodotto
- **products**: catalogo prodotti
- **orders**: ordini effettuati dagli utenti
- **order_items**: righe d'ordine con quantità e prezzo storico

### Relazioni
- Un utente può avere molti ordini → `users 1:N orders`
- Una categoria può contenere molti prodotti → `categories 1:N products`
- Un ordine può avere molte righe → `orders 1:N order_items`
- Un prodotto può comparire in molte righe ordine → `products 1:N order_items`

---

## Come eseguirlo

### 1. Crea un database PostgreSQL
```sql
CREATE DATABASE ecommerce_db;
```

### 2. Esegui gli script in ordine
```bash
psql -U postgres -d ecommerce_db -f sql/01_schema.sql
psql -U postgres -d ecommerce_db -f sql/02_seed.sql
psql -U postgres -d ecommerce_db -f sql/03_queries.sql
psql -U postgres -d ecommerce_db -f sql/04_indexes_and_optimization.sql
```

---

## Scelte progettuali

### 1. `order_items.unit_price`
Il prezzo viene salvato anche nella tabella delle righe ordine perchè può cambiare nel tempo, ma un ordine deve mantenere il valore storico del momento dell'acquisto.

### 2. `CHECK` constraints
Sono presenti vincoli per evitare dati assurdi, ad esempio:
- prezzo negativo
- quantità <= 0
- stock negativo

### 3. `UNIQUE` su email e SKU
- `users.email` è univoca
- `products.sku` è univoco

Questo evita duplicati logici.

### 4. Normalizzazione
Il progetto è strutturato in modo da evitare ridondanze inutili:
- dati utente separati dagli ordini
- dati prodotto separati dalle righe ordine
- categorie centralizzate

---

## Query incluse
Nel file `sql/03_queries.sql` trovi esempi realistici di:

- elenco ordini con nome utente
- dettaglio righe ordine con nome prodotto
- totale speso per utente
- top prodotti più venduti
- fatturato per categoria
- utenti che non hanno mai ordinato
- query con filtro su data e stato ordine

---

## Bonus: ottimizzazione
Nel file `sql/04_indexes_and_optimization.sql` trovi:

- indici su foreign key
- indici su colonne usate spesso nei filtri
- indice composito sugli ordini
---

## Esempi di query utili

### Ordini con utente
```sql
SELECT o.order_id,
       u.first_name,
       u.last_name,
       o.order_date,
       o.status,
       o.total_amount
FROM orders o
JOIN users u ON u.user_id = o.user_id
ORDER BY o.order_date DESC;
```

### Prodotti venduti per categoria
```sql
SELECT c.name AS category,
       p.name AS product,
       SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p   ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
GROUP BY c.name, p.name
ORDER BY total_units_sold DESC;
```
