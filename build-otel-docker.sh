#! /bin/bash

docker build -t shukawam/k8s-helidon-app-otel \
    --build-arg OTEL_EXPORTER_OTLP_TRACES_HEADERS="authorization=dataKey <your-private-data-key>" \
    --build-arg OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=<oci-apm-otel-tracing-endpoint> \
    --build-arg OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=<oci-apm-otel-metrics-endpoint> \
    --build-arg OTEL_EXPORTER_OTLP_METRICS_HEADERS="authorization=dataKey <your-private-data-key>" \
    -f Dockerfile.otel \
    .
