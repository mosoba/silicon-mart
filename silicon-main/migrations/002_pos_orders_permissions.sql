GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON TABLE public.orders TO anon;
GRANT SELECT, INSERT, UPDATE ON TABLE public.orders TO authenticated;

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow POS and admin to insert orders" ON public.orders;
CREATE POLICY "Allow POS and admin to insert orders"
ON public.orders
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow POS and admin to read orders" ON public.orders;
CREATE POLICY "Allow POS and admin to read orders"
ON public.orders
FOR SELECT
TO anon, authenticated
USING (true);

DROP POLICY IF EXISTS "Allow POS and admin to update orders" ON public.orders;
CREATE POLICY "Allow POS and admin to update orders"
ON public.orders
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);
