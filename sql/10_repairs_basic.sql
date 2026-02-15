\echo === RUNNING BASIC REPAIRS ===

-- =========================================
-- BASIC SAFE REPAIRS
-- nur sichere automatische Fixes
-- =========================================

-- ---------------------------------
-- REPAIR INVALID GEOMETRY
-- ---------------------------------
UPDATE public.field_geometry_version
SET geom = ST_MakeValid(geom)
WHERE NOT ST_IsValid(geom);


-- ---------------------------------
-- NORMALIZE TO MULTIPOLYGON
-- ---------------------------------
UPDATE public.field_geometry_version
SET geom = ST_Multi(geom)
WHERE GeometryType(geom) <> 'MULTIPOLYGON';


-- ---------------------------------
-- RECOMPUTE AREA
-- ---------------------------------
UPDATE public.field_geometry_version
SET area_m2 = ST_Area(ST_Transform(geom, 3857));
