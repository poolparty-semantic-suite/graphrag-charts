# GraphRAG Helm Chart

Welcome to the official Helm chart for GraphRAG by Graphwise! This Helm chart makes it easy to deploy and manage the
GraphRAG system on your Kubernetes cluster.

Make sure to check the official [GraphRAG documentation](https://help.graphwise.ai/en/graphrag.html) for further
information and workflow configurations.

## Prerequisites

* Kubernetes v1.34+
* Helm v3.8+

For development and testing, you can use [kind](https://kind.sigs.k8s.io/) to create a local Kubernetes cluster. See
the [examples/kind](examples/kind) directory for more details.

## Configuration

Create a dedicated namespace where GraphRAG will be installed:

```shell
kubectl create namespace graphrag
```

### Dependencies

GraphRAG directly depends on the following services:

* Keycloak - Authentication and authorization in the Chatbot web application
* PostgreSQL - Database for the Workflows

In case you are testing GraphRAG locally, you can follow the [development examples](examples/dev) for deploying a sample
Keycloak and PostgreSQL instances using their official Kubernetes operators. Note that these examples are only for local
testing and experimentation, **not** for production.

### Secrets

Refer to the [values.yaml](values.yaml) file for the full set of expected secrets and their exact names. You can also
use or refer to the helper script [dev.sh](examples/dev/dev.sh) on how to create some of the secrets.

#### Container Images

The container images for GraphRAG are not public. You need to be provided with credentials for accessing the
container registry at https://maven.ontotext.com. You can contact our [sales](mailto:sales@graphwise.ai) team for more
information or submit an enquiry at https://graphwise.ai/contact/.

Once you have the credentials, you can create a Kubernetes secret for the container registry:

```shell
kubectl -n graphrag create secret docker-registry graphwise-private \
        --docker-server=maven.ontotext.com \
        --docker-username=<username> \
        --docker-password=<password>
```

You can then use it with the global `imagePullSecrets` field in [values.yaml](values.yaml):

```yaml
global:
  imagePullSecrets:
    - name: graphwise-private
```

#### License

GraphRAG Workflows relies on a https://n8n.io/ commercial license for certain features. If you have one, you can create
a Secret:

```shell
kubectl -n graphrag create secret generic graphrag-workflows-license \
        --from-literal=LICENSE_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
```

And use it by configuring the `workflows.license` section in [values.yaml](values.yaml):

```yaml
workflows:
  license:
    existingSecret: graphwise-workflows-license
    licenseKey: LICENSE_KEY
    tenantId: 1234567890 # Your unique tenant ID
```

#### GraphRAG Conversation Database Credentials

Other than the cconatiner pull secret and the Workflows license secret, the Helm chart expects you to provide a few
additional but required Secret objects for the different GraphRAG services.

`graphrag-conversation-database-credentials` should contain credentials for creating and connecting to a DuckDB
instance inside the GraphRAG Conversation service. By default, the chart expects the following keys in this Secret:

* `username` - Username for the DuckDB database
* `password` - Password for the DuckDB database

You can create this Secret by running the following command:

```shell
kubectl -n graphrag create secret generic graphrag-conversation-database-credentials \
        --from-literal=username="graphrag" \
        --from-literal=password="<secret-password-for-duck-db>"
```

If you are using a different name or keys for this Secret, you can update the following section
in [values.yaml](values.yaml):

```yaml
conversation:
  configuration:
    duckdb:
      credentials:
        existingSecret: <your-secret-name>
```

#### GraphRAG Conversation Keycloak Secrets

`graphrag-conversation-keycloak-secrets` should contain a client credentials secret for the GraphRAG Conversation
service used to authenticate with Keycloak. By default, the chart expects the following key in this Secret:

* `client-secret` - Keycloak confidential client secret value

You can create this Secret by running the following command:

```shell
kubectl -n graphrag create secret generic graphrag-conversation-keycloak-secrets \
        --from-literal=client-secret='<client-secret-for-keycloak>'
```

If you are using a different name or keys for this Secret, you can update the `conversation.configuration.keycloak`
section in [values.yaml](values.yaml).

#### GraphRAG Workflows Encryption

`graphrag-workflows-encryption` should contain the key that encrypts sensitive data in the GraphRAG Workflows service.
By default, the chart expects the following key in this Secret:

- `N8N_ENCRYPTION_KEY`

You can create this Secret by running the following command:

```shell
kubectl -n graphrag create secret generic graphrag-workflows-encryption \
        --from-literal=N8N_ENCRYPTION_KEY="<the-encryption-key>"
```

If you are using a different name or keys for this Secret, you can update the `workflows.configuration.encryption`
section in [values.yaml](values.yaml).

#### GraphRAG Workflows Database Credentials

`graphrag-workflows-postgres-app` should contain the credentials the GraphRAG Workflows uses for connecting to a
PostgreSQL instance. By default, the chart expects the following key in this Secret:

* `username` - Username for the PostgreSQL database
* `password` - Password for the PostgreSQL database

#### GraphRAG Components Secrets

For GraphRAG Components service, you need to create a secret containing the credentials for connecting to the vector
database. For example, if you are using OpenSearch in AWS, you can create the following secrets:

**Vector database credentials**

```shell
kubectl -n graphrag create configmap graphrag-components-vector-database \
  --from-literal=VECTOR_STORE='opensearch' \
  --from-literal=OPENSEARCH_ENDPOINT='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' \
  --from-literal=VECTOR_INDEX='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' \
  --from-literal=VECTOR_FIELD_NAME='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
```

**AWS credentials**

```shell
kubectl -n graphrag create secret generic graphrag-components-aws-credentials \
  --from-literal=AWS_REGION='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' \
  --from-literal=AWS_ACCESS_KEY_ID='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' \
  --from-literal=AWS_SECRET_ACCESS_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
```

You can then use these secrets by configuring the `components.configuration.extra` section in
[values.yaml](values.yaml):

```yaml
components:
  configuration:
    existingProperties:
      - secretRef:
          name: graphrag-components-vector-database
      - secretRef:
          name: graphrag-components-aws-credentials
```

Please refer to the official documentation for further information about how to configure the
services https://help.graphwise.ai/en/graphrag.html.

### Extra Configuration

The GraphRAG Helm charts are designed to be customized and reconfigured in a myriad of ways:

* Providing additional environment variables to the subcharts via `extraEnv` and `extraEnvFrom`
* Configuring additional volumes and volume mounts to the subcharts via `extraVolumes` and `extraVolumeMounts`
* Providing additional init containers via `extraInitContainers`
* Disabling default resources like ingresses, services, persistence and providing your own
* Overriding the default values.yaml files
* And so on

Refer to the [values.yaml](values.yaml) file of each sub-chart for more details.

For simplicity, we have fixed the resource names, so they can be easily referenced across the default configurations.
You can override this by providing a different values.yaml file, but you must take care of service references.

Furthermore, we have configured the Ingress resources to use the `127.0.0.1.nip.io` domain name so for any non-test
deployment, you need to override this.

### Examples

You can find examples of how to use the GraphRAG Helm charts in the [examples/](examples) directory:

* [examples/dev](examples/dev) - How to deploy GraphRAG for development and testing purposes
* [examples/kind](examples/kind) - How to deploy a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io/)
* [examples/nginx-ingress](examples/nginx-ingress) - How to expose the GraphRAG services using the NGINX Ingress
  controller

## Install

Once you have prepared all required configurations and secrets, you can execute the following command:

```shell
helm --namespace graphrag upgrade --install --dependency-update -f <your values overrides> graphrag graphwise-graphrag/graphrag
```

### Post-Install

### GraphRAG Workflows Dependencies

**Important**: The workflows might contain references and URLs to the GraphRAG services, so make sure they match the
actual service names in the cluster. You can check the service names by running:

```shell
kubectl -n graphrag get svc
```

### Production

The GraphRAG Helm chart is designed to be used in a production environment but is not opinionated about the underlying
infrastructure. This means that you need to fine-tune the Helm chart values to match your specific environment and use
case. This includes:

* Storage classes and disk sizes
* Resource requests and limits
* Ingress controllers and annotations
* TLS certificates for SSL/TLS
* Network policies
* etc.

Additionally, we recommended to:

* Use a managed Kubernetes cluster like [AWS EKS](https://aws.amazon.com/eks/)
  or [Azure AKS](https://azure.microsoft.com/en-us/products/kubernetes-service)
* Configure multi-replica deployments of the services and their dependencies for better availability, throughput and
  fault tolerance.

## Uninstall

To remove your GraphRAG deployment, run the following command:

```shell
helm --namespace graphrag uninstall graphrag
```

### Persistence

There might be leftover resources that need to be cleaned up manually, such as Persistent Volume Claims and their
associated Persistent
Volumes. This largely depends on your Kubernetes cluster, the persistence settings and related Helm overrides.

You can check for these resources by running:

```shell
kubectl -n graphrag get pvc,pv
```

It's up to you to decide whether to delete these resources or not.
