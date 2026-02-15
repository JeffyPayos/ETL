from sqlalchemy import create_engine
import geopandas as gpd
from pathlib import Path

# Pfad zu deinen Daten
data_dir = Path("D:/geodata-projekt/data")

# GeoJSON oder GeoPackage laden
gdf_all = gpd.read_file(data_dir / "harmonized_all.geojson")

# PostgreSQL-Verbindung
engine = create_engine(
    "postgresql://postgres:postgres123@localhost:5432/geodata")



# Daten in PostGIS schreiben
gdf_all.to_postgis(
    name="etl_harmonized",
    con=engine,
    if_exists="replace",
    index=False
)

print("🟢 Daten erfolgreich in PostGIS geladen!")
