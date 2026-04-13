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
# Preparing namespaces
#
kubectl create namespace graphrag
kubectl create namespace keycloak
kubectl create namespace cnpg-system

#
# Install an NGINX ingress controller
#
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

#
# Install metrics server to track the container resources
#
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ || true
helm repo update metrics-server
helm upgrade \
    --install \
    --namespace kube-system \
    --set args[0]=--kubelet-insecure-tls \
    metrics-server \
    metrics-server/metrics-server

#
# Installing the CNCF PostgreSQL operator
#

helm repo add cnpg https://cloudnative-pg.github.io/charts || true
helm repo update cnpg
helm upgrade \
  --install \
  --namespace cnpg-system \
  --create-namespace \
  cnpg \
  cnpg/cloudnative-pg

#
# Installing Keycloak operator
#

kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
kubectl -n keycloak apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/kubernetes.yml

#
# Creating common secrets
#
if [ -f ~/.ontotext/maven-user ] && [ -f ~/.ontotext/maven-pass ]; then
  kubectl -n "$NAMESPACE" create secret docker-registry graphwise \
          --docker-server=maven.ontotext.com \
          --docker-username="$(cat ~/.ontotext/maven-user | tr -d '[:space:]')" \
          --docker-password="$(cat ~/.ontotext/maven-pass | tr -d '[:space:]')" \
          --docker-email=ontotext.com || true
  echo "Created image pull secret for https://maven.ontotext.com"
else
  echo "Missing user and pass for https://maven.ontotext.com image pull secret, skipping..."
fi
