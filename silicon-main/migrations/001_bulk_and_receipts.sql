ALTER TABLE public.products
  ADD COLUMN IF NOT EXISTS parent_id text REFERENCES products(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS unit_factor numeric DEFAULT 1,
  ADD COLUMN IF NOT EXISTS is_bulk boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS weight_kg numeric DEFAULT 0,
  ADD COLUMN IF NOT EXISTS pack_size int DEFAULT 1,
  ADD COLUMN IF NOT EXISTS pack_label varchar;

CREATE INDEX IF NOT EXISTS idx_products_parent_id ON public.products(parent_id);

CREATE TABLE IF NOT EXISTS public.product_conversions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  split_batch_id uuid DEFAULT gen_random_uuid(),
  parent_product_id text NOT NULL,
  parent_qty_used numeric NOT NULL,
  child_product_id text NOT NULL,
  child_qty_produced numeric NOT NULL,
  cost_per_child_unit numeric DEFAULT 0,
  variance_kg numeric DEFAULT 0,
  staff_name varchar,
  notes text,
  created_at timestamp DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_conv_batch ON public.product_conversions(split_batch_id);
CREATE INDEX IF NOT EXISTS idx_conv_parent ON public.product_conversions(parent_product_id);
CREATE INDEX IF NOT EXISTS idx_conv_created ON public.product_conversions(created_at);

GRANT SELECT, INSERT ON public.product_conversions TO anon;

CREATE TABLE IF NOT EXISTS public.stock_receipts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id text NOT NULL,
  packs_received int NOT NULL,
  pieces_per_pack int NOT NULL,
  total_pieces int NOT NULL,
  cost_per_pack numeric,
  staff_name varchar,
  notes text,
  created_at timestamp DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_receipts_product ON public.stock_receipts(product_id);
CREATE INDEX IF NOT EXISTS idx_receipts_created ON public.stock_receipts(created_at);

GRANT SELECT, INSERT ON public.stock_receipts TO anon;
