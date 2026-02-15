\echo === RUNNING SEMANTIC & INTEGRATION CHECKS ===

-- ====================================================
-- SEMANTIC & INTEGRATION SCENARIOS
-- ====================================================


-- ---------------------------------
-- SEMANTIC_INCOMPLETE (Parcelle schwach beschrieben)
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'SEMANTIC_INCOMPLETE',
  'SEMANTIC',
  'WARNING',
  'Parcelle has weak semantic attributes',
  'Enrich attributes before integration'
FROM public.field_geometry_version
WHERE source = 'Parcelles'
AND (name = 'unknown' OR name IS NULL);


-- ---------------------------------
-- MULTI_SOURCE_FIELD
-- Feld hat mehrere Quellen-Versionen
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  MIN(version_id),
  field_id,
  'MULTI_SOURCE_FIELD',
  'INTEGRATION',
  'INFO',
  'Field has multiple source versions',
  'Use integration policy to select preferred geometry'
FROM public.field_geometry_version
GROUP BY field_id
HAVING COUNT(DISTINCT source) > 1;


-- ---------------------------------
-- VERSION_DRIFT_LARGE_AREA
-- Versionen gleiche field_id aber große Flächenabweichung
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  MIN(version_id),
  field_id,
  'VERSION_DRIFT_AREA',
  'INTEGRATION',
  'WARNING',
  'Large area difference between versions',
  'Check similarity and drift before merge'
FROM public.field_geometry_version
GROUP BY field_id
HAVING MAX(area_m2) > MIN(area_m2) * 1.5;


-- ---------------------------------
-- SOURCE_SIMULATED
-- Simulationsquelle erkannt
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'SOURCE_SIMULATED',
  'INTEGRATION',
  'INFO',
  'Geometry comes from simulated source',
  'Use only for algorithm testing'
FROM public.field_geometry_version
WHERE source LIKE 'SIM_%';
