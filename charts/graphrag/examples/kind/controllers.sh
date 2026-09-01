#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Installing the NGINX Ingress controller
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
# Installing the CNPG PostgreSQL operator
#

kubectl create namespace cnpg-system
helm repo add cnpg https://cloudnative-pg.github.io/charts || true
helm repo update cnpg
helm upgrade \
  --install \
  --namespace cnpg-system \
  --create-namespace \
  cnpg \
  cnpg/cloudnative-pg

#
# Installing the Keycloak operator
#

kubectl create namespace keycloak
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
kubectl -n keycloak apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/kubernetes.yml
