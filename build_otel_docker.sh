#! /bin/bash

docker build -t shukawam/k8s-helidon-app-otel \
    --build-arg OTEL_EXPORTER_OTLP_TRACES_HEADERS="Authorization=Basic c2h1a2F3YW1AZ21haWwuY29tOlNQbHd6N2ttcHdjUzNsVm4=" \
    --build-arg OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=https://openobserve.shukawam.me/api/default/traces \
    -f Dockerfile.otel \
    .
