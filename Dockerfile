ARG base_image=python:3-slim-bullseye

FROM ${base_image}

RUN pip install --no-cache-dir requests jsonschema rfc3987

WORKDIR /opt/resource/

COPY src/* .

WORKDIR /opt/schema/

COPY schema/* .
