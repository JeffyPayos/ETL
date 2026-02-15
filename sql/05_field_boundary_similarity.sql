-- =====================================================
-- Field Boundary Similarity Analysis (stable)
-- =====================================================

DROP TABLE IF EXISTS public.field_similarity_candidates;

CREATE TABLE public.field_similarity_candidates (
    version_id_a bigint,
    version_id_b bigint,
    source_a text,
    source_b text,
    intersection_m2 double precision,
    area_a_m2 double precision,
    area_b_m2 double precision,
    hausdorff_dist double precision,
    overlap_ratio double precision
);


INSERT INTO public.field_similarity_candidates
SELECT
    a.version_id,
    b.version_id,
    a.source,
    b.source,

    ST_Area(ST_Intersection(a.geom, b.geom)::geography),
    ST_Area(a.geom::geography),
    ST_Area(b.geom::geography),

    ST_HausdorffDistance(a.geom, b.geom),

    CASE
      WHEN LEAST(
        ST_Area(a.geom::geography),
        ST_Area(b.geom::geography)
      ) > 0
      THEN
        ST_Area(ST_Intersection(a.geom, b.geom)::geography)
        /
        LEAST(
          ST_Area(a.geom::geography),
          ST_Area(b.geom::geography)
        )
      ELSE 0
    END

FROM public.field_geometry_version a
JOIN public.field_geometry_version b
  ON a.version_id < b.version_id
 AND a.source <> b.source
 AND ST_DWithin(a.geom, b.geom, 0.001);   -- ~100m



DROP TABLE IF EXISTS public.field_similarity_matches;

CREATE TABLE public.field_similarity_matches AS
SELECT *
FROM public.field_similarity_candidates
WHERE overlap_ratio > 0.5
   OR hausdorff_dist < 0.01;


CREATE INDEX IF NOT EXISTS idx_fsm_overlap
ON public.field_similarity_matches(overlap_ratio);
