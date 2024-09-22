function add_kube_attr(tag, timestamp, record)

  -- Split the tag into its components
  local stripped_tag = tag:match("kube%.var%.log%.containers%.(.*)%.log")
  local podName, namespaceName, containerName, containerID = stripped_tag:match("([^_]+)_([^_]+)_(.*)%-(.*)")

  -- Extract the log message
  local log = record["message"]

  -- Use otel semantic convetions for k8s metadata
  -- https://opentelemetry.io/docs/specs/semconv/resource/k8s/
  record["k8s.pod.name"] = podName
  record["k8s.namespace.name"] = namespaceName
  record["k8s.container.name"] = containerName
  record["k8s.container.id"] = containerID
  record["log"] = log
  record["message"] = nil

  return 1, timestamp, record
end