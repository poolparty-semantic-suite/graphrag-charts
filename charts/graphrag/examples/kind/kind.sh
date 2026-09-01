#!/usr/bin/env bash

set -o errexit
set -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CLUSTER_NAME=${CLUSTER_NAME:-"graphrag"}
NAMESPACE=${NAMESPACE:-"graphrag"}

#
# Recreate the KIND cluster
#
kind delete cluster --name "${CLUSTER_NAME}" || true
kind create cluster --name "${CLUSTER_NAME}" --config ${SCRIPT_DIR}/kind-config.yaml

#
# Preparing namespace for GraphRAG
#
kubectl create namespace ${NAMESPACE}

#
# Installing required controllers and operators
#
${SCRIPT_DIR}/controllers.sh

#
# Creating common secrets
#
if [ -f ~/.ontotext/maven-user ] && [ -f ~/.ontotext/maven-pass ]; then
  kubectl -n "${NAMESPACE}" create secret docker-registry graphwise \
          --docker-server=maven.ontotext.com \
          --docker-username="$(cat ~/.ontotext/maven-user | tr -d '[:space:]')" \
          --docker-password="$(cat ~/.ontotext/maven-pass | tr -d '[:space:]')" \
          --docker-email=ontotext.com || true
  echo "Created image pull secret for https://maven.ontotext.com"
else
  echo "Missing user and pass for https://maven.ontotext.com image pull secret, skipping..."
fi
