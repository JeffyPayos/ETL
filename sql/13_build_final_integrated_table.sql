\echo === BUILD FINAL INTEGRATED FIELD TABLE (FIXED) ===

DROP TABLE IF EXISTS public.final_integrated_fields;

CREATE TABLE public.final_integrated_fields AS

WITH policy_choice AS (

  SELECT DISTINCT
    d.chosen_version_id AS version_id
  FROM public.field_integration_decision d

),

per_field_policy AS (

  SELECT v.*
  FROM public.field_geometry_version v
  JOIN policy_choice p
    ON v.version_id = p.version_id

),

per_field_fallback AS (

  SELECT DISTINCT ON (field_id) *
  FROM public.field_geometry_version
  WHERE is_current = true
  ORDER BY field_id, version_id DESC

),

combined AS (

  SELECT * FROM per_field_policy
  UNION ALL
  SELECT f.*
  FROM per_field_fallback f
  WHERE NOT EXISTS (
    SELECT 1
    FROM per_field_policy p
    WHERE p.field_id = f.field_id
  )

)

SELECT
  field_id,
  version_id,
  source,
  type,
  name,
  area_m2,
  run_id,
  geom
FROM combined;


CREATE INDEX idx_final_fields_geom
ON public.final_integrated_fields
USING GIST (geom);

\echo === FINAL TABLE READY (FIXED) ===
