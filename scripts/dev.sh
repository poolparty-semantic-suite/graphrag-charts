#!/usr/bin/env bash

set -o errexit
set -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_DIR="$(cd "${SCRIPT_DIR}/../examples/dev" && pwd)"

# Keycloak + postgres

kubectl -n keycloak create secret generic postgres-superuser \
    --from-literal=password='change-me-super'

kubectl -n keycloak create secret generic keycloak-postgres-user \
    --from-literal=username=keycloak \
    --from-literal=password='change-me-app'

kubectl -n keycloak apply -f ${DEV_DIR}/postgres-keycloak.yaml
echo "Waiting for cluster/keycloak-postgres"
kubectl -n keycloak wait cluster/keycloak-postgres \
  --for=condition=Ready \
  --timeout=300s

kubectl -n keycloak apply -f ${DEV_DIR}/keycloak.yaml
echo "Waiting for keycloak/graphrag-keycloak"
kubectl -n keycloak wait keycloak/graphrag-keycloak \
  --for=condition=Ready \
  --timeout=300s

kubectl -n keycloak apply -f ${DEV_DIR}/keycloak-realm-import.yaml
echo "Waiting for keycloakrealmimport/graphrag-realm-example"
kubectl -n keycloak wait keycloakrealmimport/graphrag-realm-example \
  --for=condition=Done \
  --timeout=300s

KEYCLOAK_TEMP_ADMIN_PASS=$(kubectl -n keycloak get secret graphrag-keycloak-initial-admin -o jsonpath='{.data.password}' | base64 -d; echo)
echo "Keycloak temp administrator password: ${KEYCLOAK_TEMP_ADMIN_PASS}"

# n8n postgres

kubectl -n graphrag create secret generic n8n-postgres-superuser \
  --from-literal=password='change-me-super'

kubectl -n graphrag create secret generic n8n-postgres-user \
  --from-literal=username=n8n \
  --from-literal=password='change-me-app'

kubectl -n graphrag apply -f ${DEV_DIR}/postgres-n8n.yaml
echo "Waiting for cluster/graphrag-postgres-n8n"
kubectl -n graphrag wait cluster/graphrag-postgres-n8n \
  --for=condition=Ready \
  --timeout=300s

# graphrag conversation

kubectl -n graphrag create secret generic graphrag-conversation-database-credentials \
  --from-literal=spring.datasource.username='graphrag_conversation' \
  --from-literal=spring.datasource.password='change-me'

kubectl -n graphrag create secret generic graphrag-conversation-keycloak-client \
  --from-literal=spring.security.oauth2.client.registration.keycloak.client-id='conversation-api-client' \
  --from-literal=spring.security.oauth2.client.registration.keycloak.client-secret='change-me-please' \
  --from-literal=spring.security.oauth2.client.registration.keycloak.scope='openid'

# n8n

kubectl -n graphrag create secret generic graphrag-n8n-database-credentials \
  --from-literal=DB_POSTGRESDB_USER='n8n' \
  --from-literal=DB_POSTGRESDB_PASSWORD='change-me-app'
