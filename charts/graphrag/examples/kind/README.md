# Local Kubernetes With KIND

This example shows how to deploy a local Kubernetes cluster with [kind](https://kind.sigs.k8s.io/) for evaluation and
testing of GraphRAG.

## Deployment

Using the provided [kind.sh](kind.sh) script will:

- Deploy a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io/) with 1 master and 3 worker nodes
- Create required namespaces for GraphRAG
- Deploy the NGINX Ingress controller for exposing the services over HTTP/HTTPS
- Deploy the Kubernetes metrics server for tracking container resource usage
- Deploy the CNPG PostgreSQL operator
- Deploy the Keycloak operator
- Create a registry secret for pulling container images from our container registry

Just run the following command:

```shell
./kind.sh
```

> [!NOTE]
> You need to have port 80 and 443 available on your host machine, otherwise the containers won't be able to bind to
> them.

> [!NOTE]
> The script can automatically create a container pull secret from `~/.ontotext/maven-user` and `~/.ontotext/maven-pass`
> if they exist.

After the script finishes, you can follow the example instructions in the [examples/dev/README.md](../dev/README.md) to
deploy the pre-requisite services. There is also a helper script [dev.sh](../dev/dev.sh) that will do the necessary
steps for you. Finally, check what further instructions are necessary in [README.md](../../README.md) of the main Helm
chart.

## Troubleshooting

If your KIND cluster is not working properly, or it simply cannot be created, please
check https://kind.sigs.k8s.io/docs/user/known-issues

### Too many open files

One of the regular issues is when the host OS default inotify resources have a low default limit,
see https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files
