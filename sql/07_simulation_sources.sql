-- =========================================
-- Simulation zusätzlicher Quellen
-- gleiche Feldgrenze – leicht verändert
-- =========================================

-- Basis: version_id = 3 (NRW Feld)

-- SIM_MACHINE_A – leicht verschoben
INSERT INTO public.field_geometry_version(
  field_id,
  run_id,
  source,
  type,
  name,
  area_m2,
  geom
)
SELECT
  field_id,
  run_id,
  'SIM_MACHINE_A',
  type,
  name,
  area_m2,
  ST_Translate(geom, 0.00015, 0.00015)
FROM public.field_geometry_version
WHERE version_id = 3;


-- SIM_MACHINE_B – leicht skaliert
INSERT INTO public.field_geometry_version(
  field_id,
  run_id,
  source,
  type,
  name,
  area_m2,
  geom
)
SELECT
  field_id,
  run_id,
  'SIM_MACHINE_B',
  type,
  name,
  area_m2,
  ST_Scale(geom, 1.001, 0.999)
FROM public.field_geometry_version
WHERE version_id = 3;
