# GraphRAG Helm Dev Environment Example

The following guide will help you get started with the GraphRAG Helm chart in your local Kubernetes cluster by
installing an example Keycloak instance and the necessary PostgreSQL databases and secrets.

## Prerequisites

Note that some of these steps are already handled by the [kind.sh](../kind/kind.sh) script:

- Local Kubernetes cluster
- Namespaces
- CNPG Operator
- Keycloak Operator

## Setup

Just execute the following script:

```shell
./dev.sh
```

And it will handle the following:

- Create a PostgreSQL database for Keycloak, see [keycloak-postgres.yaml](keycloak-postgres.yaml)
- Create a Keycloak instance, see [keycloak.yaml](keycloak.yaml)
- Import an example Keycloak realm, see [keycloak-realm-import.yaml](keycloak-realm-import.yaml)
- Create a PostgreSQL database for GraphRAG Workflows, see [workflows-postgres.yaml](workflows-postgres.yaml)
- Create a Secret for GraphRAG Conversation database credentials with a random password
- Create a Secret for GraphRAG Conversation Keycloak client secret credentials based on the client
  in [keycloak-realm-import.yaml](keycloak-realm-import.yaml)

## Install

Follow the main [README.md](../../README.md#configuration) of the GraphRAG umbrella Helm chart for creating the
necessary additional Kubernetes secrets and then proceed with the standard installation steps
in [README.md](../../README.md#install).

You can also use the local [values.yaml](values.yaml) file (from the chart's root directory) with:

```shell
helm --namespace graphrag upgrade --install --dependency-update -f examples/dev/values.yaml graphrag .
```
