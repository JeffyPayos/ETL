-- =====================================================
-- Integration Policy Layer
-- Decide which boundary becomes canonical
-- =====================================================

DROP TABLE IF EXISTS public.field_integration_decision;

CREATE TABLE public.field_integration_decision AS
SELECT
    m.version_id_a,
    m.version_id_b,
    a.source AS source_a,
    b.source AS source_b,

    -- 🎯 Policy Regel:
    -- NRW bevorzugen, sonst größere Fläche

    CASE
      WHEN a.source = 'NRW' THEN m.version_id_a
      WHEN b.source = 'NRW' THEN m.version_id_b

      WHEN a.area_m2 >= b.area_m2 THEN m.version_id_a
      ELSE m.version_id_b
    END AS chosen_version_id,

    m.overlap_ratio,
    m.hausdorff_dist

FROM public.field_similarity_matches m
JOIN public.field_geometry_version a
  ON a.version_id = m.version_id_a
JOIN public.field_geometry_version b
  ON b.version_id = m.version_id_b;
