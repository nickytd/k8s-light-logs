# Fluent-bit setup

## Components

This setup installs a fluent-operator and fluent-bits (as daemonset) collecting containers logs and systemd logs for kubelet and containerd services  running on the nodes.

It leverages the [opentelemetry-envelope processor](https://docs.fluentbit.io/manual/pipeline/processors/opentelemetry-envelope) to pack the logs in `otel` format and adds additional `attributes` via `lua` scripting.

## Setup

By default the fluent-operator deploys a pipeline with predefined set of input, filter and output plugins. However the current version of the operator does not support out of the box the configuration mode (yaml) required by the fluent-bit to specify the `opentelemetry-envelope` [config](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/configuration-file).

> This functionality is only exposed in YAML configuration and not in classic configuration mode due to the restriction of nested levels of configuration.

Thus this setup switches the configuration in `yaml` format and applies the required fluent-bit plugins.

### Pipelines

#### Container logs pipeline

- [Tail Input](/fluent-bit/plugins/input-kube.yaml) -> [Lua Filter](/fluent-bit/plugins/filters-kube.yaml) -> [Output OTLP](/fluent-bit/plugins/output-vl-k8s-otlp.yaml)

#### Systemd logs

- [Systemd Input](/fluent-bit/plugins/input-systemd.yaml) -> [Lua Filter](/fluent-bit/plugins/filters-systemd.yaml) -> [Output OTLP](/fluent-bit/plugins/output-vl-journald-otlp.yaml)
