import geopandas as gpd
from pathlib import Path

data_dir = Path("D:/geodata-projekt/data")

gdf_osm = gpd.read_file(data_dir / "export.geojson")
gdf_shp = gpd.read_file(data_dir / "2022_gmk_flur_EPSG25832_Shape")
gdf_parcelles = gpd.read_file(data_dir / "MonParcellaire.gpkg", layer="parcelles")

print("OSM CRS:", gdf_osm.crs)
print("NRW CRS:", gdf_shp.crs)
print("Parcelles CRS:", gdf_parcelles.crs)

