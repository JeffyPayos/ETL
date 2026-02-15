import geopandas as gpd
from shapely.geometry import Point
from sqlalchemy import create_engine

# Verbindung
engine = create_engine(
    "postgresql+psycopg://postgres:NeuesPasswort123!@127.0.0.1:5432/geodata"
)

# Mini-Testdaten
gdf = gpd.GeoDataFrame(
    {
        "name": ["A", "B"],
        "value": [1, 2],
        "geometry": [Point(7.1, 50.7), Point(7.2, 50.8)],
    },
    crs="EPSG:4326",
)

# In PostGIS schreiben
gdf.to_postgis(
    name="test_points",
    con=engine,
    if_exists="replace",
    index=False
)

print("✅ Testdaten erfolgreich in PostGIS geladen.")
