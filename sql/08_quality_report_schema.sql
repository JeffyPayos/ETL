-- ============================================
-- QUALITY REPORT TABLE
-- sammelt alle Szenario-Check Ergebnisse
-- ============================================

DROP TABLE IF EXISTS public.quality_report;

CREATE TABLE public.quality_report (
    report_id      BIGSERIAL PRIMARY KEY,

    version_id     BIGINT,
    field_id       BIGINT,

    check_code     TEXT,      -- z.B. GEOM_INVALID
    check_group    TEXT,      -- z.B. GEOMETRY / ATTRIBUTE / SPATIAL

    severity       TEXT,      -- INFO / WARNING / ERROR

    message        TEXT,
    recommendation TEXT,

    detected_at    TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_quality_report_version
ON public.quality_report(version_id);

CREATE INDEX idx_quality_report_group
ON public.quality_report(check_group);
