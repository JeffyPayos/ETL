import subprocess
from pathlib import Path

BASE = Path("D:/geodata-projekt")

PYTHON_SCRIPTS = [
    "src/extract.py",
    "src/transform.py",
    "src/transform_attributes.py",
    "src/load_postGis.py",
]

SQL_FILES = [
    "sql/04_versioning_load.sql",
    "sql/05_field_boundary_similarity.sql",
    "sql/06_integration_policy.sql",
    "sql/08_quality_report_schema.sql",
    "sql/09_quality_checks_basic.sql",
    "sql/10_repairs_basic.sql",
    "sql/11_quality_checks_spatial.sql",
    "sql/12_quality_checks_semantic_integration.sql",
    "sql/13_build_final_integrated_table.sql ",
    "sql/14_final_dedup.sql ",

]

PSQL = r"C:\Program Files\PostgreSQL\18\bin\psql.exe"

PSQL_BASE = [
    PSQL,
    "-U", "postgres",
    "-d", "geodata",
    "-h", "127.0.0.1",
    "-p", "5432",
]


def run_python(script):
    path = BASE / script
    print(f"\n🐍 RUN {script}")
    subprocess.run(["python", str(path)], check=True)


def run_sql(file):
    path = BASE / file
    print(f"\n🗄️ RUN {file}")
    subprocess.run(PSQL_BASE + ["-f", str(path)], check=True)


def main():

    print("\n=== FULL ETL + QUALITY PIPELINE START ===")

    for s in PYTHON_SCRIPTS:
        run_python(s)

    for f in SQL_FILES:
        run_sql(f)

    print("\n✅ PIPELINE COMPLETE")


if __name__ == "__main__":
    main()
