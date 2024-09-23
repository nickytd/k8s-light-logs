#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$(dirname $0)
source $dir/../.include.sh

version=${1:-"0.34.8"}
namespace=${2:-"victoria-logs"}
operator_chart_url=${3:-"https://github.com/VictoriaMetrics/helm-charts/releases/download/victoria-metrics-operator-$version/victoria-metrics-operator-$version.tgz"}


function deploy-victorialogs(){

    kubectl apply \
        --namespace $namespace \
        -f $dir/victoria-logs.yaml

}

create-namespace $namespace
deploy-operator $namespace "victoria-metrics-operator" $operator_chart_url
deploy-victorialogs