-- Country Table with Auto-Incrementing ID
CREATE TABLE IF NOT EXISTS public.country (
  id SERIAL PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  alpha_2 CHAR(2) NOT NULL,
  alpha_3 CHAR(3) NOT NULL,
  country_code VARCHAR(255) NOT NULL,
  iso_3166_2 VARCHAR(255),
  region VARCHAR(255) NOT NULL,
  sub_region VARCHAR(255) NOT NULL,
  intermediate_region VARCHAR(100),
  region_code VARCHAR(255) NOT NULL,
  sub_region_code VARCHAR(255) NOT NULL,
  intermediate_region_code VARCHAR(250),
  is_activate BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.country IS 'Stores country data including ISO codes and region information.';
ALTER TABLE public.country ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Countries are viewable by everyone." ON public.country
  FOR SELECT USING (true);
CREATE TRIGGER update_country_timestamp BEFORE UPDATE ON public.country
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();
