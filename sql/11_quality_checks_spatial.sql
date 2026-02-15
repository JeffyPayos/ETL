\echo === RUNNING ADVANCED SPATIAL CHECKS ===

-- ============================================
-- ADVANCED SPATIAL SCENARIO CHECKS
-- Bounding Box / Range / Complexity / Outliers
-- ============================================


-- ---------------------------------
-- BBOX_OUT_OF_RANGE (Europa grob)
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'BBOX_OUT_OF_RANGE',
  'SPATIAL',
  'ERROR',
  'Geometry outside expected Europe bounds',
  'Check CRS or source dataset'
FROM public.field_geometry_version
WHERE
  ST_XMin(geom) < -20
  OR ST_XMax(geom) > 40
  OR ST_YMin(geom) < 30
  OR ST_YMax(geom) > 75;


-- ---------------------------------
-- COORDINATE_RANGE_WARNING (Deutschland enger)
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'COORD_RANGE_WARNING',
  'SPATIAL',
  'WARNING',
  'Geometry outside Germany bbox',
  'Verify if dataset mixes countries'
FROM public.field_geometry_version
WHERE
  ST_XMin(geom) < 5
  OR ST_XMax(geom) > 16
  OR ST_YMin(geom) < 47
  OR ST_YMax(geom) > 56;


-- ---------------------------------
-- AREA_EXTREME_SMALL
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'AREA_EXTREME_SMALL',
  'GEOMETRY',
  'WARNING',
  'Area extremely small',
  'Check if geometry is fragment'
FROM public.field_geometry_version
WHERE area_m2 < 100;


-- ---------------------------------
-- AREA_EXTREME_LARGE
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'AREA_EXTREME_LARGE',
  'GEOMETRY',
  'WARNING',
  'Area extremely large',
  'Check if multiple fields merged'
FROM public.field_geometry_version
WHERE area_m2 > 50000000;


-- ---------------------------------
-- GEOM_TOO_COMPLEX
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'GEOM_TOO_COMPLEX',
  'GEOMETRY',
  'INFO',
  'Geometry has very high vertex count',
  'Consider simplification'
FROM public.field_geometry_version
WHERE ST_NPoints(geom) > 5000;
