# Dockerfile for the Metadata Editor FastAPI data-processing service.
#
# Installs the geospatial extras (requirements-geospatial.txt) so the
# /geospatial/* endpoints work (MT-58). GDAL's Python bindings (osgeo) must be
# built against the exact libgdal on the system, so the pip `gdal` is pinned to
# `gdal-config --version`. Debian trixie ships GDAL 3.10.3, the floor in
# requirements-geospatial.txt. Two stages keep the compiler out of the image.
FROM python:3.11-slim-trixie AS build
RUN apt-get update \
 && apt-get install -y --no-install-recommends libgdal-dev g++ \
 && rm -rf /var/lib/apt/lists/*
RUN python -m venv /venv
ENV PATH=/venv/bin:$PATH
COPY requirements.txt requirements-geospatial.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir "numpy==2.2.4" setuptools wheel \
 && pip install --no-cache-dir --no-build-isolation "gdal==$(gdal-config --version)" \
 && grep -vE '^\s*gdal' requirements-geospatial.txt > /tmp/req-geo.txt \
 && pip install --no-cache-dir -r /tmp/req-geo.txt

FROM python:3.11-slim-trixie
RUN apt-get update \
 && apt-get install -y --no-install-recommends libgdal36 \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /venv /venv
ENV PATH=/venv/bin:$PATH
WORKDIR /app
COPY . .
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
