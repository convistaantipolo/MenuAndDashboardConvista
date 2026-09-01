-- ============================================================================
-- CON VISTA — ORDERING APP SCHEMA REFERENCE
-- Project: zmcalfrnhmhjjpjlpleh (ap-southeast-1)
-- ============================================================================
-- This file documents the tables the ordering app reads/writes.
-- Sections marked "ALREADY LIVE" already exist in your Supabase project as-is
-- — they are included here for reference only, do NOT re-run them.
-- The one section marked "MIGRATION TO RUN" is the only change needed.
-- ============================================================================


-- ============================================================================
-- ALREADY LIVE: categories
-- ============================================================================
-- create table categories (
--   id          bigint generated always as identity primary key,
--   name        text unique not null,          -- e.g. 'Grilled', 'Beverages'
--   sort_order  integer default 0,
--   created_at  timestamptz default now()
-- );


-- ============================================================================
-- ALREADY LIVE: menu_items
-- ============================================================================
-- create table menu_items (
--   id          text primary key,
--   category    text references categories(name) on update cascade,
--   name        text not null,
--   description text default '',
--   price       numeric default 0,
--   available   boolean default true,           -- app only shows available = true
--   sort_order  integer default 0,
--   created_at  timestamptz default now(),
--   updated_at  timestamptz default now()
-- );


-- ============================================================================
-- ALREADY LIVE: app_settings  (used by the staff dashboard PIN gate)
-- ============================================================================
-- create table app_settings (
--   id                      boolean primary key default true check (id),
--   restaurant_name         text default 'Con Vista',
--   fb_username             text default '',
--   order_email             text default '',
--   currency                text default '₱',
--   admin_pin               text default '1234',   -- staff dashboard PIN
--   service_charge_percent  numeric default 5
-- );


-- ============================================================================
-- ALREADY LIVE: orders  (current columns)
-- ============================================================================
-- create table orders (
--   id                       uuid primary key default gen_random_uuid(),
--   table_number             text default '',
--   customer_name            text default '',
--   notes                    text default '',
--   items                    jsonb default '[]',
--   subtotal                 numeric default 0,
--   service_charge_percent   numeric default 0,
--   service_charge           numeric default 0,
--   total                    numeric default 0,
--   currency                 text default '₱',
--   payment_method           text default 'Pending',
--   paid                     boolean default false,   -- true = Paid, false = Unpaid
--   status                   text default 'new'
--                            check (status in ('new','preparing','ready','served')),
--   created_at               timestamptz default now()
-- );
--
-- Status mapping used by this app:
--   'new'        -> "Pending"     (default on insert)
--   'preparing'  -> "Preparing"
--   'served'     -> "Completed"
--   ('ready' already exists in the check constraint from your kitchen system
--    and is left untouched — the customer/staff apps here just don't use it)


-- ============================================================================
-- MIGRATION STATUS: ✅ APPLIED
-- The order_type column below has already been added to your live database.
-- This section is kept for reference only — do not re-run it.
-- ============================================================================
alter table orders
  add column if not exists order_type text
  default 'dine-in'
  check (order_type in ('dine-in', 'takeout', 'pickup'));

-- Optional but recommended: speeds up the staff dashboard's "last 24h" query
create index if not exists idx_orders_created_at on orders (created_at desc);
create index if not exists idx_orders_status on orders (status);


-- ============================================================================
-- RLS NOTE
-- ============================================================================
-- Both apps use the public anon key. Your existing RLS policies already allow
-- the customer menu to read menu_items/categories and insert into orders,
-- and allow the staff dashboard to read/update orders and read app_settings.
-- If the staff dashboard update ever fails silently, check that orders has an
-- UPDATE policy for the anon role (not just INSERT/SELECT).
