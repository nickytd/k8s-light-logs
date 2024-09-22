#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$(dirname $0)

version=${1:-"0.6.3"}
namespace=${2:-"victoria-logs"}
chart_url=${3:-"https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-logs-single-$version/victoria-logs-single-$version.tgz"}


function create-namespace(){
    # Create namespace
    kubectl create namespace $namespace \
        --dry-run=client -o yaml | kubectl apply -f -
}

function deploy-victorialogs(){
    helm upgrade victorialogs $chart_url \
        --namespace $namespace \
        --values $dir/values.yaml \
        --install \
        --wait \
        --timeout 300s
}

create-namespace
deploy-victorialogs