-- =========================================
-- FarmSPT Versioning Schema
-- =========================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.etl_run (
  run_id        BIGSERIAL PRIMARY KEY,
  started_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  description   TEXT
);

CREATE TABLE IF NOT EXISTS public.field_entity (
  field_id      BIGSERIAL PRIMARY KEY,
  field_key     TEXT UNIQUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.field_geometry_version (
  version_id    BIGSERIAL PRIMARY KEY,
  field_id      BIGINT NOT NULL REFERENCES public.field_entity(field_id) ON DELETE CASCADE,
  run_id        BIGINT NOT NULL REFERENCES public.etl_run(run_id) ON DELETE CASCADE,
  source        TEXT NOT NULL,
  type          TEXT NOT NULL,
  name          TEXT,
  area_m2       DOUBLE PRECISION,
  geom          geometry(MultiPolygon, 4326) NOT NULL,
  valid_from    TIMESTAMPTZ NOT NULL DEFAULT now(),
  valid_to      TIMESTAMPTZ,
  is_current    BOOLEAN NOT NULL DEFAULT true
);

CREATE INDEX IF NOT EXISTS idx_fgv_geom
  ON public.field_geometry_version USING gist (geom);

CREATE INDEX IF NOT EXISTS idx_fgv_field_id
  ON public.field_geometry_version(field_id);

CREATE INDEX IF NOT EXISTS idx_fgv_run_id
  ON public.field_geometry_version(run_id);

CREATE INDEX IF NOT EXISTS idx_fgv_source
  ON public.field_geometry_version(source);

COMMIT;
