create extension if not exists pgcrypto;

create table if not exists public.products (
 id uuid primary key default gen_random_uuid(), name text not null, slug text unique,
 description text default '', price numeric not null default 0, status text not null default 'READY',
 stock integer not null default 0, sizes jsonb not null default '["S","M","L","XL"]'::jsonb,
 featured boolean not null default false, image_url text default '', created_at timestamptz not null default now()
);
create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(), order_code text unique not null,
 customer_name text not null, customer_phone text not null, customer_address text not null,
 note text default '', total_amount numeric not null default 0, payment_status text not null default 'PENDING',
 whatsapp_sent boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.order_items (
 id uuid primary key default gen_random_uuid(), order_id uuid not null references public.orders(id) on delete cascade,
 product_id uuid references public.products(id) on delete set null, product_name text not null,
 size text default '', quantity integer not null default 1, price numeric not null default 0,
 subtotal numeric not null default 0, created_at timestamptz not null default now()
);
create table if not exists public.store_settings (
 id integer primary key default 1, whatsapp_number text default '', instagram text default '@kardobu',
 qris_image_url text default '', hero_title text default 'WEAR YOUR IDENTITY.',
 hero_subtitle text default 'Premium streetwear dengan karakter kuat.', updated_at timestamptz not null default now()
);
insert into public.store_settings(id) values(1) on conflict(id) do nothing;

alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.store_settings enable row level security;

drop policy if exists "products_public_read" on public.products;
drop policy if exists "products_admin_insert" on public.products;
drop policy if exists "products_admin_update" on public.products;
drop policy if exists "products_admin_delete" on public.products;
drop policy if exists "settings_public_read" on public.store_settings;
drop policy if exists "settings_admin_update" on public.store_settings;
drop policy if exists "orders_public_insert" on public.orders;
drop policy if exists "orders_admin_read" on public.orders;
drop policy if exists "orders_admin_update" on public.orders;
drop policy if exists "items_public_insert" on public.order_items;
drop policy if exists "items_admin_read" on public.order_items;

create policy "products_public_read" on public.products for select using(true);
create policy "products_admin_insert" on public.products for insert to authenticated
with check((auth.jwt()->>'email')='kardobustore@gmail.com');
create policy "products_admin_update" on public.products for update to authenticated
using((auth.jwt()->>'email')='kardobustore@gmail.com') with check((auth.jwt()->>'email')='kardobustore@gmail.com');
create policy "products_admin_delete" on public.products for delete to authenticated
using((auth.jwt()->>'email')='kardobustore@gmail.com');

create policy "settings_public_read" on public.store_settings for select using(true);
create policy "settings_admin_update" on public.store_settings for update to authenticated
using((auth.jwt()->>'email')='kardobustore@gmail.com') with check((auth.jwt()->>'email')='kardobustore@gmail.com');

create policy "orders_public_insert" on public.orders for insert to anon,authenticated with check(true);
create policy "orders_admin_read" on public.orders for select to authenticated
using((auth.jwt()->>'email')='kardobustore@gmail.com');
create policy "orders_admin_update" on public.orders for update to authenticated
using((auth.jwt()->>'email')='kardobustore@gmail.com') with check((auth.jwt()->>'email')='kardobustore@gmail.com');

create policy "items_public_insert" on public.order_items for insert to anon,authenticated with check(true);
create policy "items_admin_read" on public.order_items for select to authenticated
using((auth.jwt()->>'email')='kardobustore@gmail.com');
