import geopandas as gpd
from pathlib import Path

data_dir = Path("D:/geodata-projekt/data")

# harmonisierte Datei laden
gdf_all = gpd.read_file(data_dir / "harmonized_all.geojson")

# Ausgabe GeoPackage
output_gpkg = data_dir / "harmonized_all.gpkg"
gdf_all.to_file(output_gpkg, driver="GPKG")

print("🟢 GPKG erfolgreich gespeichert:", output_gpkg)
