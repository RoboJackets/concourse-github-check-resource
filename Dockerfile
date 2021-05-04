ARG base_image=python:3.8-alpine

FROM ${base_image}

RUN pip install --no-cache-dir requests jsonschema rfc3987

WORKDIR /opt/resource/

COPY src/* .

WORKDIR /opt/schema/

COPY schema/* .
