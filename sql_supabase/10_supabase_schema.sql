-- ShopSmart schema per Supabase / PostgreSQL

create table if not exists public.users (
  id bigint generated always as identity primary key,
  full_name varchar(120) not null,
  email varchar(255) not null unique,
  city varchar(100),
  created_at date not null default current_date
);

create table if not exists public.categories (
  id bigint generated always as identity primary key,
  name varchar(100) not null unique
);

create table if not exists public.products (
  id bigint generated always as identity primary key,
  category_id bigint not null references public.categories(id),
  name varchar(150) not null,
  description text,
  price numeric(10,2) not null check (price >= 0),
  stock integer not null default 0 check (stock >= 0),
  is_active boolean not null default true,
  created_at date not null default current_date
);

create table if not exists public.orders (
  id bigint generated always as identity primary key,
  user_id bigint not null references public.users(id),
  order_date date not null default current_date,
  status varchar(20) not null check (status in ('processing', 'completed', 'cancelled')),
  total_amount numeric(10,2) not null default 0 check (total_amount >= 0)
);

create table if not exists public.order_items (
  id bigint generated always as identity primary key,
  order_id bigint not null references public.orders(id) on delete cascade,
  product_id bigint not null references public.products(id),
  quantity integer not null check (quantity > 0),
  unit_price numeric(10,2) not null check (unit_price >= 0),
  line_total numeric(10,2) generated always as (quantity * unit_price) stored,
  unique (order_id, product_id)
);

create index if not exists idx_products_category_id on public.products(category_id);
create index if not exists idx_orders_user_id on public.orders(user_id);
create index if not exists idx_orders_user_status_date on public.orders(user_id, status, order_date desc);
create index if not exists idx_order_items_order_id on public.order_items(order_id);
create index if not exists idx_order_items_product_id on public.order_items(product_id);

insert into public.users (full_name, email, city, created_at)
values
  ('Mario Rossi', 'mario.rossi@email.com', 'Milano', '2026-01-10'),
  ('Laura Bianchi', 'laura.bianchi@email.com', 'Roma', '2026-01-15'),
  ('Giulia Verdi', 'giulia.verdi@email.com', 'Torino', '2026-02-03'),
  ('Luca Neri', 'luca.neri@email.com', 'Napoli', '2026-02-18')
on conflict (email) do nothing;

insert into public.categories (name)
values ('Accessori'), ('Monitor'), ('Computer')
on conflict (name) do nothing;

insert into public.products (category_id, name, description, price, stock, is_active, created_at)
select c.id, x.name, x.description, x.price, x.stock, true, x.created_at
from (
  values
    ('Accessori', 'Mouse Wireless', 'Mouse leggero per uso quotidiano', 24.90, 42, '2026-01-10'::date),
    ('Accessori', 'Tastiera Meccanica', 'Tastiera con switch meccanici', 79.90, 15, '2026-01-12'::date),
    ('Monitor', 'Monitor 27 pollici', 'Display QHD per ufficio e studio', 219.00, 9, '2026-01-15'::date),
    ('Computer', 'Notebook Pro 14', 'Portatile ad alte prestazioni', 999.00, 5, '2026-01-18'::date)
) as x(category_name, name, description, price, stock, created_at)
join public.categories c on c.name = x.category_name
where not exists (
  select 1 from public.products p where p.name = x.name
);

insert into public.orders (user_id, order_date, status, total_amount)
select u.id, x.order_date, x.status, x.total_amount
from (
  values
    ('mario.rossi@email.com', '2026-03-01'::date, 'completed', 104.80),
    ('laura.bianchi@email.com', '2026-03-03'::date, 'processing', 219.00),
    ('mario.rossi@email.com', '2026-03-05'::date, 'completed', 999.00),
    ('giulia.verdi@email.com', '2026-03-07'::date, 'cancelled', 79.90)
) as x(email, order_date, status, total_amount)
join public.users u on u.email = x.email
where not exists (
  select 1 from public.orders o where o.user_id = u.id and o.order_date = x.order_date and o.total_amount = x.total_amount
);

insert into public.order_items (order_id, product_id, quantity, unit_price)
select o.id, p.id, x.quantity, x.unit_price
from (
  values
    ('2026-03-01'::date, 'Mouse Wireless', 1, 24.90),
    ('2026-03-01'::date, 'Tastiera Meccanica', 1, 79.90),
    ('2026-03-03'::date, 'Monitor 27 pollici', 1, 219.00),
    ('2026-03-05'::date, 'Notebook Pro 14', 1, 999.00),
    ('2026-03-07'::date, 'Tastiera Meccanica', 1, 79.90)
) as x(order_date, product_name, quantity, unit_price)
join public.orders o on o.order_date = x.order_date
join public.products p on p.name = x.product_name
on conflict (order_id, product_id) do nothing;

create or replace view public.products_with_category as
select
  p.id,
  p.name,
  c.name as category_name,
  p.price,
  p.stock,
  p.is_active
from public.products p
join public.categories c on c.id = p.category_id;

create or replace view public.order_summary as
select
  o.id as order_id,
  u.full_name as customer_name,
  o.order_date,
  o.status,
  o.total_amount,
  string_agg(p.name || ' x' || oi.quantity, ', ' order by p.name) as items_summary
from public.orders o
join public.users u on o.user_id = u.id
join public.order_items oi on oi.order_id = o.id
join public.products p on p.id = oi.product_id
group by o.id, u.full_name, o.order_date, o.status, o.total_amount;

alter table public.users enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

create policy if not exists "Public read users" on public.users for select to anon using (true);
create policy if not exists "Public read categories" on public.categories for select to anon using (true);
create policy if not exists "Public read products" on public.products for select to anon using (true);
create policy if not exists "Public read orders" on public.orders for select to anon using (true);
create policy if not exists "Public read order_items" on public.order_items for select to anon using (true);

grant usage on schema public to anon;
grant select on public.users, public.categories, public.products, public.orders, public.order_items to anon;
grant select on public.products_with_category, public.order_summary to anon;
