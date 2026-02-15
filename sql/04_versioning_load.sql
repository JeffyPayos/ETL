-- =========================================
-- Insert Versioned Data from etl_harmonized
-- =========================================

-- 1️⃣ ETL Run erzeugen
INSERT INTO public.etl_run(description)
VALUES ('Versioned load from etl_harmonized')
RETURNING run_id;

-- 2️⃣ Feld-Entitäten erzeugen
INSERT INTO public.field_entity(field_key)
SELECT
  md5(
    COALESCE(source,'') || '|' ||
    COALESCE(type,'')   || '|' ||
    COALESCE(name,'')   || '|' ||
    encode(ST_AsEWKB(ST_Multi(geometry)), 'hex')
  )
FROM public.etl_harmonized
ON CONFLICT (field_key) DO NOTHING;

-- 3️⃣ Versionen schreiben
INSERT INTO public.field_geometry_version(
  field_id, run_id, source, type, name, area_m2, geom
)
SELECT
  fe.field_id,
  (SELECT max(run_id) FROM public.etl_run),
  h.source,
  h.type,
  h.name,
  h.area_m2,
  ST_Multi(h.geometry)::geometry(MultiPolygon,4326)
FROM public.etl_harmonized h
JOIN public.field_entity fe
  ON fe.field_key = md5(
    COALESCE(h.source,'') || '|' ||
    COALESCE(h.type,'')   || '|' ||
    COALESCE(h.name,'')   || '|' ||
    encode(ST_AsEWKB(ST_Multi(h.geometry)), 'hex')
  );
