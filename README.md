# Graphwise GraphRAG Helm Charts

This repository contains the Helm charts suite for deploying GraphRAG by Graphwise.

## Quickstart

```
helm repo add graphrag-charts https://poolparty-semantic-suite.github.io/graphrag-charts
helm repo update graphrag-charts
```

Follow the further instructions in the [README.md](charts/graphrag/README.md) of the `charts/graphrag/` folder.

## About Graphwise

<p align="center">
  <a href="https://graphwise.ai/">
    <picture>
      <img src="https://graphwise.ai/wp-content/uploads/2024/10/graphwise-logo-horizontal-slogan.svg" alt="Graphwise logo" title="Graphwise" height="75">
    </picture>
  </a>
</p>

Graphwise brings confidence to search, analytics, and AI. Our platform is built for enterprises where precision is a
must or complexity is high. We transform disparate data silos into a trusted enterprise knowledge graph, providing a
governed layer of context for consistent, reliable AI applications. At Graphwise, we turn enterprise data from a
liability into an asset. We build the “trusted semantic backbone” that connects disconnected data silos and integrates
your proprietary domain knowledge into your AI. This allows you to govern your AI , boost model accuracy , and drive a
positive ROI.

## Prerequisites

* Kubernetes v1.32+
* Helm v3.8+

### Container Images

The container images for GraphRAG are not public. You need to be provided with credentials for accessing the
container registry at https://maven.ontotext.com. You can contact our [sales](mailto:sales@graphwise.ai) team for more
information or submit an enquiry at https://graphwise.ai/contact/.

## Structure

The Helm deployment for GraphRAG consists of the following Helm charts:

- [charts/graphrag/](charts/graphrag) - This is an umbrella chart that deploys the whole GraphRAG suite
- [charts/graphrag-chatbot/](charts/graphrag-chatbot) - Helm chart for deploying the Chatbot web application
- [charts/graphrag-components/](charts/graphrag-components) - Helm chart for deploying the Components service for
  vectors searches
- [charts/graphrag-conversation/](charts/graphrag-conversation) - Helm chart for deploying the Conversation service with
  DuckDB
- [charts/graphrag-workflows/](charts/graphrag-workflows) - Helm chart for deploying a workflow engine

## Local Deployment

You can deploy the whole GraphRAG system locally by using the provided [scripts/kind.sh](scripts/kind.sh) script which
will:

- Deploy a local Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) with 1 master and 3 worker nodes
- Deploy the NGINX Ingress controller for exposing the services over HTTP/HTTPS
- Deploy the Kubernetes metrics server for tracking container resource usage
- Create several namespaces for GraphRAG
- Create a registry secret for pulling container images from our container registry

Just run the following command:

```shell
./scripts/kind.sh
```

Note: You need to have port 80 and 443 available on your host machine, otherwise the containers won't be able to bind to
them. Note: The script can automatically create a container pull secret from `~/.ontotext/maven-user` and
`~/.ontotext/maven-pass` if they exist.

After the script finishes, you can follow the example instructions in the [README.md](examples/dev/README.md) of the
`examples/dev/` folder to deploy the pre-requisite services. There is also a helper script [dev.sh](scripts/dev.sh) that
will do the necessary steps for you.

Finally, check what further instructions are necessary in [README.md](charts/graphrag/README.md) of the main Helm chart.

### Troubleshooting

If your KIND cluster is not working properly or it simply cannot be created, please
check https://kind.sigs.k8s.io/docs/user/known-issues

#### Too many open files

One of the regular issues is when the host OS default inotify resources have a low default limit,
see https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files
