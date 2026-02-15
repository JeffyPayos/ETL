import geopandas as gpd
import pandas as pd
from pathlib import Path

data_dir = Path("D:/geodata-projekt/data")

# Harmonisierte Versionen laden
gdf_osm = gpd.read_file(data_dir / "osm_4326.geojson")
gdf_nrw = gpd.read_file(data_dir / "nrw_4326.geojson")
gdf_parc = gpd.read_file(data_dir / "parcelles_4326.geojson")

# -------------------------
# 1️⃣ OSM harmonisieren
# -------------------------
gdf_osm_h = gdf_osm.copy()
gdf_osm_h["source"] = "OSM"
gdf_osm_h["type"] = gdf_osm_h["landuse"]
gdf_osm_h["name"] = gdf_osm_h["operator"].fillna("unknown")

# Fläche korrekt berechnen in m²
gdf_osm_h["area_m2"] = gdf_osm_h.to_crs("EPSG:3857").geometry.area

gdf_osm_h = gdf_osm_h[["source", "type", "name", "area_m2", "geometry"]]

# -------------------------
# 2️⃣ NRW harmonisieren
# -------------------------
gdf_nrw_h = gdf_nrw.copy()
gdf_nrw_h["source"] = "NRW"
gdf_nrw_h["type"] = gdf_nrw_h["art"]
gdf_nrw_h["name"] = gdf_nrw_h["gemeinde"].fillna("unknown")

gdf_nrw_h["area_m2"] = gdf_nrw_h.to_crs("EPSG:3857").geometry.area

gdf_nrw_h = gdf_nrw_h[["source", "type", "name", "area_m2", "geometry"]]

# -------------------------
# 3️⃣ Parcelles harmonisieren
# -------------------------
gdf_parc_h = gdf_parc.copy()
gdf_parc_h["source"] = "Parcelles"
gdf_parc_h["type"] = "parcelle"
gdf_parc_h["name"] = gdf_parc_h["nom"].fillna("unknown")

gdf_parc_h["area_m2"] = gdf_parc_h.to_crs("EPSG:3857").geometry.area

gdf_parc_h = gdf_parc_h[["source", "type", "name", "area_m2", "geometry"]]

# -------------------------
# 4️⃣ Zusammenführen
# -------------------------
gdf_all = gpd.GeoDataFrame(
    pd.concat([gdf_osm_h, gdf_nrw_h, gdf_parc_h], ignore_index=True),
    crs="EPSG:4326"
)

# Speichern in ein gemeinsames Endformat
output = data_dir / "harmonized_all.geojson"
gdf_all.to_file(output, driver="GeoJSON")

print("\n🟢 TRANSFORM SCHRITT 3 ERFOLGREICH!")
print("Gemeinsame Datei gespeichert als:", output)
print("Gesamtzahl Features:", len(gdf_all))
print(gdf_all.head())

