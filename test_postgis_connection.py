from sqlalchemy import create_engine, text

engine = create_engine(
    "postgresql+psycopg://postgres:NeuesPasswort123!@127.0.0.1:5432/geodata"
)

with engine.connect() as conn:
    result = conn.execute(text("SELECT PostGIS_Version();"))
    print(result.fetchone())
