import geopandas as gpd
from pathlib import Path

data_dir = Path("D:/geodata-projekt/data")

osm_file = data_dir / "export.geojson"
shp_folder = data_dir / "2022_gmk_flur_EPSG25832_Shape"
gpkg_file = data_dir / "MonParcellaire.gpkg"

print("\n=== 1) Lese OSM GeoJSON ein ===")
gdf_osm = gpd.read_file(osm_file)
print(" -> OSM geladen:", gdf_osm.shape)

print("\n=== 2) Lese NRW Shapefile ein ===")
gdf_shp = gpd.read_file(shp_folder)
print(" -> Shapefile geladen:", gdf_shp.shape)

print("\n=== 3) Lese GeoPackage Layer 'parcelles' ein ===")
gdf_gpkg = gpd.read_file(gpkg_file, layer="parcelles")
print(" -> GPKG 'parcelles' geladen:", gdf_gpkg.shape)

print("\n🟢 EXTRACT erfolgreich abgeschlossen!")

