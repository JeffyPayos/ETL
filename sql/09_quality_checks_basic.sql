\echo === RUNNING BASIC QUALITY CHECKS ===

-- =====================================================
-- BASIS SZENARIO CHECKS
-- schreibt Ergebnisse in quality_report
-- =====================================================

-- ---------------------------------
-- GEOM_NULL
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'GEOM_NULL',
  'GEOMETRY',
  'ERROR',
  'Geometry is NULL',
  'Remove record or reload source geometry'
FROM public.field_geometry_version
WHERE geom IS NULL;


-- ---------------------------------
-- GEOM_INVALID
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'GEOM_INVALID',
  'GEOMETRY',
  'ERROR',
  'Geometry is not valid',
  'Run ST_MakeValid in repair step'
FROM public.field_geometry_version
WHERE geom IS NOT NULL
AND NOT ST_IsValid(geom);


-- ---------------------------------
-- TYPE_NOT_MULTIPOLYGON
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'TYPE_NOT_MULTIPOLYGON',
  'GEOMETRY',
  'WARNING',
  'Geometry is not MultiPolygon',
  'Normalize using ST_Multi(geom)'
FROM public.field_geometry_version
WHERE GeometryType(geom) <> 'MULTIPOLYGON';


-- ---------------------------------
-- SRID_WRONG
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'SRID_WRONG',
  'SPATIAL',
  'ERROR',
  'SRID is not 4326',
  'Transform geometry to EPSG:4326'
FROM public.field_geometry_version
WHERE ST_SRID(geom) <> 4326;


-- ---------------------------------
-- AREA_ZERO
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'AREA_ZERO',
  'GEOMETRY',
  'ERROR',
  'Area is zero or negative',
  'Recompute area or inspect geometry'
FROM public.field_geometry_version
WHERE area_m2 <= 0;


-- ---------------------------------
-- NAME_UNKNOWN
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  version_id,
  field_id,
  'NAME_UNKNOWN',
  'SEMANTIC',
  'INFO',
  'Name is unknown',
  'Try to enrich from external metadata'
FROM public.field_geometry_version
WHERE name = 'unknown';


-- ---------------------------------
-- DUPLICATE_GEOMETRY
-- ---------------------------------
INSERT INTO public.quality_report
(version_id, field_id, check_code, check_group, severity, message, recommendation)
SELECT
  a.version_id,
  a.field_id,
  'DUPLICATE_GEOMETRY',
  'STRUCTURE',
  'WARNING',
  'Geometry duplicates another version',
  'Consider deduplication by similarity policy'
FROM public.field_geometry_version a
JOIN public.field_geometry_version b
  ON a.version_id <> b.version_id
 AND ST_Equals(a.geom, b.geom);
