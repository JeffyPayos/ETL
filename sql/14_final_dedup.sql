\echo === FINAL WINNER DEDUP STEP ===

DROP TABLE IF EXISTS public.final_integrated_fields_dedup;

CREATE TABLE public.final_integrated_fields_dedup AS

SELECT DISTINCT ON (field_id)
  *
FROM public.final_integrated_fields
ORDER BY
  field_id,
  area_m2 DESC;   


CREATE INDEX idx_final_dedup_geom
ON public.final_integrated_fields_dedup
USING GIST (geom);

\echo === FINAL DEDUP TABLE READY ===
