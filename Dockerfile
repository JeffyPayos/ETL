FROM python:3.11-slim

WORKDIR /app

# Systemlibs für GeoPandas / Fiona / GDAL
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

COPY requirements.txt .
RUN pip install --no-cache-dir \
    geopandas \
    sqlalchemy \
    psycopg2-binary \
    shapely \
    pyogrio \
    fiona \
    pandas

COPY src ./src
COPY sql ./sql
COPY data ./data

CMD ["python", "src/run_pipeline.py"]
