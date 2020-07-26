FROM python:3

RUN pip install --no-cache-dir requests

WORKDIR /opt/resource/

COPY src/* .
