#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$(dirname $0)
source $dir/../.include.sh

version=${1:-"v3.2.0"}
namespace=${2:-"fluent-bit"}
operator_chart_url=${3:-"https://github.com/fluent/fluent-operator/releases/download/$version/fluent-operator.tgz"}

function create-lua-configmap(){
    # Create configmap for fluent-bit containing lua scripts
    kubectl create configmap lua-scripts \
        --namespace $namespace \
        --from-file=add_tag_to_record.lua=$dir/lua/add_tag_to_record.lua \
        --from-file=add_kube_attr.lua=$dir/lua/add_kube_attr.lua \
        --from-file=add_time_and_systemd_attr.lua=$dir/lua/add_time_and_systemd_attr.lua \
        --dry-run=client -o yaml | kubectl apply -f -
}

function patch-fluent-bit-config(){

    # Switch fluent-bit config file format to yaml.
    # It is required to support fluent-bit processors and fluent-operator by default uses old conf format.
    # Patch the service parsers file to use a single parsers file, as the current version of fluent-bit does not support multiple parsers files in yaml configuration format.
    #
    # This path can be removed when:
    # - fluent-bit supports multiple parsers files in yaml configuration format
    # - fluent-operator supports fluent-bit config file format in yaml by default or by configuration
    if [ ! -z $(kubectl get cfbc fluent-bit-config --namespace $namespace -o jsonpath='{.spec.service.parsersFiles}') ]; then
        kubectl patch cfbc fluent-bit-config \
            --namespace $namespace \
            --type="json" \
            --patch='[
                {"op": "remove", "path": "/spec/service/parsersFiles"},
            ]'
    fi

     kubectl patch cfbc fluent-bit-config \
     --namespace $namespace \
     --type="json" \
     --allow-missing-template-keys="true" \
     --patch='[
        {"op": "replace", "path": "/spec/configFileFormat", "value": "yaml"},
        {"op": "replace", "path": "/spec/service/parsersFile", "value": "/fluent-bit/etc/parsers.conf"},
      ]'

}

function deploy-fluent-bit(){

    kubectl apply -n $namespace \
        -f $dir/fluent-bit.yaml

}

function deploy-fluent-bit-resources(){

    kubectl apply -n $namespace \
        -f $dir/plugins/input-kube.yaml

    kubectl apply -n $namespace \
        -f $dir/plugins/input-systemd.yaml

    kubectl apply -n $namespace \
        -f $dir/plugins/filters-kube.yaml

    kubectl apply -n $namespace \
        -f $dir/plugins/filters-systemd.yaml

    kubectl apply -n $namespace \
        -f $dir/plugins/output-vl-k8s-otlp.yaml

    kubectl apply -n $namespace \
        -f $dir/plugins/output-vl-journald-otlp.yaml
}


# Fluent-bit setup
create-namespace $namespace
create-lua-configmap
deploy-operator $namespace fluent-operator $operator_chart_url
patch-fluent-bit-config
deploy-fluent-bit-resources
deploy-fluent-bit
