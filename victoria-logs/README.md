# Victoria Logs

A simple single process deployment of victoria-logs. By default the prometheus service monitor and the ingress resources are not enabled due to dependency to the corresponding components.

After successfull deployment, victoria-logs can be accessed with port forwarding of the respective service at `http://localhost:9428`.

![vmui](/images/vmui.png)

```bash
kubectl port-forward svc/vlogs-single 9428:9428 -n victoria-logs
```


## Links

- [Docs](https://docs.victoriametrics.com/victorialogs/)
- [FAQ](https://docs.victoriametrics.com/victorialogs/faq/)
- [Github Repo](https://github.com/VictoriaMetrics/VictoriaMetrics)

## Key benefits

- Optimized resource consumption - [benchmarks](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/deployment/logs-benchmark)
- High compressaion ratio in kubernetes environments
- Fast queries via a http endpoint
- Simple operation model and configuration
- [Grafana DataSource](https://github.com/VictoriaMetrics/victorialogs-datasource) plugin
- Project is in [active development](https://docs.victoriametrics.com/victorialogs/changelog/)
  - v0.29.0 - support for opentelemetry ingestion
- Lifecycle management is provider by:
  - [VM Operator](https://docs.victoriametrics.com/operator/api/#vlogs)
  - [Helm Chart](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-logs-single)

## Open topics

- Integration with [perses](https://github.com/perses/perses) is missing on the roadmaps

## Resources

- [KeyConcepts](https://docs.victoriametrics.com/victorialogs/keyconcepts/)
- [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/)
- [Project Roadmap](https://docs.victoriametrics.com/victorialogs/roadmap/)
- [Operator Custom Resource](https://docs.victoriametrics.com/operator/api/#vlogs)

### Articles

- [VictoriaLogs: an overview, run in Kubernetes, LogsQL, and Grafana](https://itnext.io/victorialogs-an-overview-run-in-kubernetes-logsql-and-grafana-88e0934a5ccd)

### Videos

- [Strategies for Efficient Log Management in Large-Scale Kubernetes Clusters](https://youtu.be/b9o9UC6xmbc?si=1NUZhYAGl0zuher_)
- [VictoriaMetrics Meetup June 2023: Introducing VictoriaLogs | Open Source Logs management](https://youtu.be/yt0ukL5X2pQ?t=1389)
- [VictoriaLogs Update June 2024](https://www.youtube.com/watch?v=hzlMA_Ae9_4&t=3660s)
