# Schema concettuale

## Diagramma relazionale semplificato

```text
users (1) --------< orders (1) --------< order_items >-------- (1) products >-------- (1) categories
```

## Tabelle

### users
- `user_id` PK
- `first_name`
- `last_name`
- `email` UNIQUE
- `phone`
- `created_at`

### categories
- `category_id` PK
- `name` UNIQUE
- `description`

### products
- `product_id` PK
- `category_id` FK → categories.category_id
- `sku` UNIQUE
- `name`
- `description`
- `price`
- `stock`
- `is_active`
- `created_at`

### orders
- `order_id` PK
- `user_id` FK → users.user_id
- `order_date`
- `status`
- `total_amount`

### order_items
- `order_item_id` PK
- `order_id` FK → orders.order_id
- `product_id` FK → products.product_id
- `quantity`
- `unit_price`
- `line_total`

## Nota di modellazione

`line_total` è una colonna generata:

```sql
line_total = quantity * unit_price
```

Serve per avere un dato immediato e coerente senza ricalcolarlo ogni volta nelle query.
