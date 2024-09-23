function create-namespace(){
    local namespace=${1}

    if [ -z "$namespace" ]; then
        echo "Namespace is required"
        return 1
    fi
    # Create namespace
    kubectl create namespace $namespace \
        --dry-run=client -o yaml | kubectl apply -f -
}

function deploy-operator(){
    local namespace=${1}
    local name=${2}
    local operator_chart_url=${3}

    if [ -z "$namespace" ]; then
        echo "Namespace is required"
        return 1
    fi

    if [ -z "$name" ]; then
        echo "Name is required"
        return 1
    fi

    if [ -z "$operator_chart_url" ]; then
        echo "Operator Chart URL is required"
        return 1
    fi

    helm upgrade $name $operator_chart_url \
        --namespace $namespace \
        --values $dir/values.yaml \
        --install \
        --wait \
        --timeout 300s

    # Wait for opentelemetry-operator deployment to be available
    kubectl wait --for=condition=Available deployment \
        -l app.kubernetes.io/name=$name \
        --namespace $namespace \
        --timeout=300s

    # Wait for opentelemetry-operator pod to be ready
    kubectl wait --for=condition=Ready pod \
        -l app.kubernetes.io/name=$name \
        --namespace $namespace \
        --timeout=300s
}