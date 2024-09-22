# k8s-victoria-otel-logstack

Contents:

- [fluent-bit](/fluent-bit/README.md)
- [victoria-logs](/victoria-logs/README.md)
- [otel-collecotr](/otel-collector/README.md)

This repo contains an example of a k8s logging stack, which is lightweight but yet performant.
There are two key guiding principles in this example:

- Use `otel` open standard data model for logs
  - [OpenTelemetry Logs](https://opentelemetry.io/docs/specs/otel/logs/data-model/)
  - [OpenTelemetry Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/)
- Use lightweight backend for persisting the cluster logs
  - [VictoriaLogs](https://docs.victoriametrics.com/victorialogs/)

The example here illustrates the deployment of log shippers, pipelines and backend using respective projects guidelines and brings the necessary additional resources and configurations. Optional components such as `prometheus` or `ingress-controller` may be installed to expose the full set of the supported scenarios.

The purpose of the repo, as of today, is to quickly provide a logging stack for k8s clusters that later can be extended to serve `production` environments. For example at the moment the repo does not provide out of the box end to end `tls` encryption configurations. The ingress endpoints and the service monitoring are not exposed by default. Those shall be added later in specific deployments.

## Components

This repo illustrates the deployment of:

- [fluent/fluent-operator](https://github.com/fluent/fluent-operator)
- [fluent-operator/fluent-bit](/fluent-bit/fluent-bit.yaml)
- [victoria-logs-single/helm chart](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-single)

And optionally:

- [open-telemetry/opentelemetry-operator](https://github.com/open-telemetry/opentelemetry-operator)
- [opentelemetry-operator/otel-collector](/otel-collector/otel-collector.yaml)

To setup the stack:

1. [Deploy](/victoria-logs/setup.sh) single instance victoria-logs
1. [Deploy](/fluent-bit/setup.sh) fluent operator and fluent-bit
1. Optionally [deploy](/otel-collector/setup.sh) the otel-collector
