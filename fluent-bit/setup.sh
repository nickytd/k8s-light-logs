#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$(dirname $0)

version=${1:-"v3.2.0"}
namespace=${2:-"fluent-bit"}
operator_chart_url=${3:-"https://github.com/fluent/fluent-operator/releases/download/$version/fluent-operator.tgz"}

function create-namespace(){
    # Create namespace
    kubectl create namespace $namespace \
        --dry-run=client -o yaml | kubectl apply -f -
}

function create-lua-configmap(){
    # Create configmap for fluent-bit containing lua scripts
    kubectl create configmap lua-scripts \
        --namespace $namespace \
        --from-file=add_tag_to_record.lua=$dir/lua/add_tag_to_record.lua \
        --from-file=add_kube_attr.lua=$dir/lua/add_kube_attr.lua \
        --from-file=add_time_and_systemd_attr.lua=$dir/lua/add_time_and_systemd_attr.lua \
        --dry-run=client -o yaml | kubectl apply -f -
}

function deploy-fluent-operator(){

    helm upgrade fluent-operator $operator_chart_url \
        --namespace $namespace \
        --values $dir/values.yaml \
        --install \
        --wait \
        --timeout 300s

    # Wait for fluent-operator deployment to be available
    kubectl wait --for=condition=Available deployment \
        -l app.kubernetes.io/name=fluent-operator \
        --namespace $namespace \
        --timeout=300s

    # Wait for fluent-operator pod to be ready
    kubectl wait --for=condition=Ready pod \
        -l app.kubernetes.io/name=fluent-operator \
        --namespace $namespace \
        --timeout=300s

    # Switch fluent-bit config file format to yaml.
    # It is required to support fluent-bit processors and fluent-operator by default uses old conf format.
    # Patch the service parsers file to use a single parsers file, as the current version of fluent-bit does not support multiple parsers files in yaml configuration format.
    #
    # This path can be removed when:
    # - fluent-bit supports multiple parsers files in yaml configuration format
    # - fluent-operator supports fluent-bit config file format in yaml by default or by configuration

     kubectl patch cfbc fluent-bit-config \
     --namespace $namespace \
     --type="json" \
     --allow-missing-template-keys="true" \
     --patch='[
        {"op": "replace", "path": "/spec/configFileFormat", "value": "yaml"},
        {"op": "remove", "path": "/spec/service/parsersFiles"},
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
create-namespace
create-lua-configmap
deploy-fluent-operator
deploy-fluent-bit-resources
deploy-fluent-bit
