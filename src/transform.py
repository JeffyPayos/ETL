import geopandas as gpd
from pathlib import Path

# Datenpfad
data_dir = Path("D:/geodata-projekt/data")

# Daten laden
gdf_osm = gpd.read_file(data_dir / "export.geojson")
gdf_shp = gpd.read_file(data_dir / "2022_gmk_flur_EPSG25832_Shape")
gdf_parc = gpd.read_file(data_dir / "MonParcellaire.gpkg", layer="parcelles")

print("=== CRS VOR Transformation ===")
print("OSM:       ", gdf_osm.crs)
print("NRW:       ", gdf_shp.crs)
print("Parcelles: ", gdf_parc.crs)

# Ziel CRS (alles in WGS84)
TARGET_CRS = "EPSG:4326"

print("\n=== Wandle ALLE Daten nach EPSG:4326 um ===")

gdf_osm_4326 = gdf_osm.to_crs(TARGET_CRS)
gdf_shp_4326 = gdf_shp.to_crs(TARGET_CRS)
gdf_parc_4326 = gdf_parc.to_crs(TARGET_CRS)

print("\n=== CRS NACH Transformation ===")
print("OSM:       ", gdf_osm_4326.crs)
print("NRW:       ", gdf_shp_4326.crs)
print("Parcelles: ", gdf_parc_4326.crs)

# Optional: Speichern der harmonisierten Versionen
gdf_osm_4326.to_file(data_dir / "osm_4326.geojson", driver="GeoJSON")
gdf_shp_4326.to_file(data_dir / "nrw_4326.geojson", driver="GeoJSON")
gdf_parc_4326.to_file(data_dir / "parcelles_4326.geojson", driver="GeoJSON")

print("\n🟢 TRANSFORM SCHRITT 1 ERFOLGREICH!")
print("Alle drei Datensätze teilen jetzt die gleiche Projektion (EPSG:4326).")
print(gdf_osm_4326.columns)
print(gdf_shp_4326.columns)
print(gdf_parc_4326.columns)
