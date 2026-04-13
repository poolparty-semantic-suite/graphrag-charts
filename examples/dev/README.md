# GraphRAG Helm Dev Examples

The following guide will help you get started with the GraphRAG Helm chart in your local Kubernetes cluster by
installing an example Keycloak instance and the necessary PostgreSQL databases.

## Prerequisites

Note that some of these steps are already handled by the [kind.sh](../../scripts/kind.sh) script.

### Namespaces

Create the following namespaces

1. `graphrag`
2. `keycloak`
3. `cnpg-system`

Use the following shell snippet:

```shell
kubectl create namespace graphrag
kubectl create namespace keycloak
kubectl create namespace cnpg-system
```

### PostgreSQL Operator

You can use the Cloud Native Computing Foundation PostgreSQL operator https://cloudnative-pg.io/.
This will give an easy way of managing PostgreSQL clusters in Kubernetes.

1. Add CNPG's Helm repository
    ```shell
    helm repo add cnpg https://cloudnative-pg.github.io/charts
    helm repo update cnpg
    ```

2. Install the operator in the expected `cnpg-system` namespace.
    ```shell
    helm upgrade \
      --install \
      --namespace cnpg-system \
      --create-namespace \
      cnpg \
      cnpg/cloudnative-pg
    ```

### Keycloak

Taken from https://www.keycloak.org/operator/installation

1. Install the Keycloak Operator CRDs
    ```shell
    kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
    kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
    ```

2. Install the operator in the expected `keycloak` namespace
    ```shell
    kubectl -n keycloak apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/kubernetes.yml
    ```

3. Create PostgreSQL superuser secret for Keycloak
    ```shell
    kubectl -n keycloak create secret generic postgres-superuser \
      --from-literal=password='change-me-super'
    ```

4. Create PostgreSQL database credentials for Keycloak
    ```shell
    kubectl -n keycloak create secret generic keycloak-postgres-user \
      --from-literal=username=keycloak \
      --from-literal=password='change-me-app'
    ```

5. Deploy a sample PostgreSQL cluster for Keycloak and **wait** for it to be ready. It could take a few minutes to pull
   and join the pods.
    ```shell
    kubectl -n keycloak apply -f postgres-keycloak.yaml
    ```

6. Install a sample Keycloak instance and **wait** for it to be ready
    ```shell
    kubectl -n keycloak apply -f keycloak.yaml
    ```

7. Create a new admin user and deprecate the temp-admin via the Keycloak admin console. You can get the temp admin
   password with:
    ```shell
    kubectl -n keycloak get secret graphrag-keycloak-initial-admin -o jsonpath='{.data.password}' | base64 -d; echo
    ```

### keycloak Realm

Import an existing sample Keycloak realm for testing with:

```shell
kubectl -n keycloak apply -f keycloak-realm-import.yaml
```

You will need to clear the realm cache via the administrative console to force the reloading of realms, otherwise you
won't see it in the
console for a while.

### N8N Database

1. Create PostgreSQL superuser secret for N8N
    ```shell
    kubectl -n graphrag create secret generic n8n-postgres-superuser \
      --from-literal=password='change-me-super'
    ```

2. Create PostgreSQL database credentials for N8N
    ```shell
    kubectl -n graphrag create secret generic n8n-postgres-user \
      --from-literal=username=n8n \
      --from-literal=password='change-me-app'
    ```

3. Deploy a sample PostgreSQL cluster for N8N
    ```shell
    kubectl -n graphrag apply -f postgres-n8n.yaml
    ```

## Install

Follow the README.md of the main GraphRAG chart for creating the necessary Kubernetes secrets and then execute the
following command from the **root** directory:

```shell
helm --namespace graphrag upgrade --install --dependency-update -f examples/dev/values.yaml graphrag charts/graphrag/
```
