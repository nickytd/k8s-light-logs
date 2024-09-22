#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$(dirname $0)

version=${1:-"0.69.0"}
namespace=${2:-"otel"}
operator_chart_url=${3:-"https://github.com/open-telemetry/opentelemetry-helm-charts/releases/download/opentelemetry-operator-$version/opentelemetry-operator-$version.tgz"}

function create-namespace(){
    # Create namespace
    kubectl create namespace $namespace \
        --dry-run=client -o yaml | kubectl apply -f -
}

function deploy-otel-operator(){
    helm upgrade opentelemetry-operator $operator_chart_url \
        --namespace $namespace \
        --values $dir/values.yaml \
        --install \
        --wait \
        --timeout 300s

    # Wait for opentelemetry-operator deployment to be available
    kubectl wait --for=condition=Available deployment \
        -l app.kubernetes.io/name=opentelemetry-operator \
        --namespace $namespace \
        --timeout=300s

    # Wait for opentelemetry-operator pod to be ready
    kubectl wait --for=condition=Ready pod \
        -l app.kubernetes.io/name=opentelemetry-operator \
        --namespace $namespace \
        --timeout=300s
}

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

create-namespace
deploy-otel-operator
deploy-otel-collector
