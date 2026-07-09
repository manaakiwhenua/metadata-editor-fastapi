# Dockerfile for the Metadata Editor FastAPI data-processing service.
#
# Mirrors the proven inline build in the web repo's docker-compose.yml
# (manaakiwhenua/metadata-editor: fastapi service). Non-geospatial base:
# requirements.txt only. The geospatial extras (requirements-geospatial.txt)
# pull GDAL and are intentionally NOT installed here - add a geospatial image
# variant when that processing path is needed on-platform.
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
