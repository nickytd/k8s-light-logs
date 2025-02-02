#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
source $dir/../.include.sh

version=${1:-"0.41.0"}
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