# k8s-light-logs

A simple logging stack for kubernetes cluster collecting logs from multiple sources:

- container logs
- systemd services
- k8s events

![k8s-victoria-otel-logstack](/images/k8s-victoria-otel-logstack.png)

It packs and delivers the logs in `opentelemetry` logs format enriching the logs with source `attributes` following the otel `semantic convention`.

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

The purpose of the repo, as of today, is to quickly provide a logging stack for k8s clusters that later can be extended to serve `production` environments. For example at the moment the repo does not provide, out of the box, end to end `tls` encryption configurations. By default, the ingress endpoints and the service monitoring are not exposed . Those shall be added later in specific deployments.

## Components

This repo illustrates the deployment of:

- [fluent-operator](https://github.com/fluent/fluent-operator)
- [fluent-operator/fluent-bit](/fluent-bit/fluent-bit.yaml)
- [victoria-metrics-operator](https://github.com/VictoriaMetrics/operator)
- [victoria-metrics-operator/victoria-logs](/victoria-logs/victoria-logs.yaml)

And optionally:

- [opentelemetry-operator](https://github.com/open-telemetry/opentelemetry-operator)
- [opentelemetry-operator/otel-collector](/otel-collector/otel-collector.yaml)

To setup the stack:

1. [Deploy](/victoria-logs/setup.sh) single instance victoria-logs
2. [Deploy](/fluent-bit/setup.sh) fluent operator and fluent-bit
3. Optionally [deploy](/otel-collector/setup.sh) the otel-collector

Or simply run

```bash
./setup.sh
```
