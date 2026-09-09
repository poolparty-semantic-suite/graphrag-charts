#!/usr/bin/env bash

set -o errexit
set -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KEYCLOAK_NAMESPACE=keycloak
GRAPHRAG_NAMESPACE=graphrag

#
# GraphRAG services namespace
#

kubectl create namespace ${GRAPHRAG_NAMESPACE} || true

#
# Keycloak PostgreSQL
#

kubectl -n ${KEYCLOAK_NAMESPACE} apply -f ${SCRIPT_DIR}/keycloak-postgres.yaml

echo "Waiting for cluster/graphrag-keycloak-postgres"
kubectl -n ${KEYCLOAK_NAMESPACE} wait cluster/graphrag-keycloak-postgres \
  --for=condition=Ready \
  --timeout=300s

#
# Keycloak
#

kubectl -n ${KEYCLOAK_NAMESPACE} apply -f ${SCRIPT_DIR}/keycloak.yaml

echo "Waiting for keycloak/graphrag-keycloak"
kubectl -n ${KEYCLOAK_NAMESPACE} wait keycloak/graphrag-keycloak \
  --for=condition=Ready \
  --timeout=300s

#
# Keycloak realm import
#

kubectl -n ${KEYCLOAK_NAMESPACE} apply -f ${SCRIPT_DIR}/keycloak-realm-import.yaml

echo "Waiting for keycloakrealmimport/graphrag-realm-example"
kubectl -n ${KEYCLOAK_NAMESPACE} wait keycloakrealmimport/graphrag-realm-example \
  --for=condition=Done \
  --timeout=300s

#
# GraphRAG Conversation
#

GRAPHRAG_CONVERSATION_DATABASE_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 24; echo)
kubectl -n ${GRAPHRAG_NAMESPACE} create secret generic graphrag-conversation-database-credentials \
        --from-literal=username="graphrag" \
        --from-literal=password="${GRAPHRAG_CONVERSATION_DATABASE_PASSWORD}" || true

# Should match what's in keycloak-realm-import.yaml or if you have provided/configured something else.
kubectl -n ${GRAPHRAG_NAMESPACE} create secret generic graphrag-conversation-keycloak-secrets \
        --from-literal=client-secret='change-me-please' || true

#
# GraphRAG Workflows PostgreSQL
#

kubectl -n ${GRAPHRAG_NAMESPACE} apply -f ${SCRIPT_DIR}/workflows-postgres.yaml

echo "Waiting for cluster/graphrag-workflows-postgres"
kubectl -n ${GRAPHRAG_NAMESPACE} wait cluster/graphrag-workflows-postgres \
  --for=condition=Ready \
  --timeout=300s

#
# GraphRAG Workflows Encryption
#

GRAPHRAG_WORKFLOWS_ENCRYPTION_SECRET=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 24; echo)
kubectl -n ${GRAPHRAG_NAMESPACE} create secret generic graphrag-workflows-encryption \
        --from-literal=N8N_ENCRYPTION_KEY="${GRAPHRAG_WORKFLOWS_ENCRYPTION_SECRET}" || true

#
# Done
#

KEYCLOAK_TEMP_ADMIN_PASS=$(kubectl -n ${KEYCLOAK_NAMESPACE} get secret graphrag-keycloak-initial-admin -o jsonpath='{.data.password}' | base64 -d; echo)
echo "Keycloak admin console: https://127.0.0.1.nip.io/auth"
echo "Keycloak initial administrator password: ${KEYCLOAK_TEMP_ADMIN_PASS}"
