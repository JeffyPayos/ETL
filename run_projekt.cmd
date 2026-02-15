@echo off
echo ==========================================
echo   GEODATA ETL + INTEGRATION PIPELINE
echo ==========================================
echo.

cd /d %~dp0

echo [ ’] Prüfe Docker...
docker --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Docker ist nicht installiert oder nicht gestartet.
    echo Bitte Docker Desktop starten und erneut versuchen.
    pause
    exit /b
)

echo [OK] Docker gefunden
echo.

echo [ ’] Starte PostGIS Datenbank (Docker)...
docker compose up -d
IF %ERRORLEVEL% NEQ 0 (
    echo Fehler beim Start von Docker Compose
    pause
    exit /b
)

echo [OK] Datenbank gestartet
echo.

echo [ ’] Warte 5 Sekunden auf DB Start...
timeout /t 5 >nul

echo [ ’] Prüfe Python...
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python nicht gefunden.
    echo Bitte Python 3.11 installieren.
    pause
    exit /b
)

echo [OK] Python gefunden
echo.

echo [ ’] Installiere benoetigte Python Pakete (falls noch nicht vorhanden)...
pip install geopandas shapely pandas sqlalchemy psycopg2-binary pyogrio fiona >nul

echo [OK] Python Pakete bereit
echo.

echo ==========================================
echo   STARTE PIPELINE
echo ==========================================
echo.

python src\run_pipeline.py

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Pipeline Fehler aufgetreten
    pause
    exit /b
)

echo.
echo ==========================================
echo   PIPELINE ERFOLGREICH ABGESCHLOSSEN
echo ==========================================
echo.

echo [ ’] Finale Feldanzahl pruefen...
docker exec -i geodata_postgis psql -U postgres -d geodata -c "SELECT COUNT(*) FROM final_integrated_fields_dedup;"

echo.
echo [ ’] Quality Report Eintraege:
docker exec -i geodata_postgis psql -U postgres -d geodata -c "SELECT check_code, COUNT(*) FROM quality_report GROUP BY check_code;"

echo.
echo Fertig.
pause
