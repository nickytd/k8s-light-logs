#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$(dirname $0)
source $dir/../.include.sh

version=${1:-"0.69.0"}
namespace=${2:-"otel"}
operator_chart_url=${3:-"https://github.com/open-telemetry/opentelemetry-helm-charts/releases/download/opentelemetry-operator-$version/opentelemetry-operator-$version.tgz"}

# Deploy the OpenTelemetry Collector with victorialogs backend
function deploy-otel-collector(){

    # Create RBAC for OpenTelemetry Collector
    # Required by the k8s-events receiver
    kubectl apply \
        --namespace $namespace \
        -f $dir/otel-k8s-events-rbac.yaml

    kubectl apply \
        --namespace $namespace \
        -f $dir/otel-collector.yaml
}

create-namespace $namespace
deploy-operator $namespace opentelemetry-operator $operator_chart_url
deploy-otel-collector
