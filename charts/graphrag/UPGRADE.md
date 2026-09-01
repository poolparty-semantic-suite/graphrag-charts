# GraphRAG Upgrade Guidelines

## 2.0.0

**Global configurations**

- `global.imagePullSecrets` no longer has a default value, you have to configure the pull secret explicitly. You don't
  need to set this if you can pull the images from another private registry without having to authenticate.

**Chatbot configurations**

- `chatbot.configurations` refer to a different Keycloak client id, adjust accoring to your existing configuration.
- `chatbot.ingress` is no longer refering to NGINX Ingress specific configurations. You can refer to the example
  in [examples/nginx-ingress](examples/nginx-ingress) on how to configure it.

**Conversation configurations**

- `conversation.configuration.properties` has new default configuration properties, tune them according to your existing
  settings.

**Components configurations**

- `components.configuration` AWS specific configuration overrides have been moved as an example in
  the [README.md](README.md#graphrag-components-secrets).

**Workflows configurations**

This is the component with most changes as we have moved to a new Helm chart:

- `workflows.configuration.license` has been moved to `workflows.license` to better align with the rest of our Helm
  charts. You only need to update the configuration block if you have overridden it.
- `workflows.license.existingSecret` now defaults to a different reference `graphrag-workflows-license`, tune it
  according to your existing secret or recreate the secret to match the chart's default.
- `workflows.configuration.encryption.existingSecret` now defaults to a different reference
  `graphrag-workflows-encryption`, tune it according to your existing secret or recreate the secret to match the chart's
  default.
- `workflows.configuration.postgresdb.host` now defaults to a different hostname `graphrag-workflows-postgres-rw`, tune
  it according to your existing database
- `workflows.configuration.postgresdb.database` now defaults to `graphrag`, tune it according to your existing database
- `workflows.configuration.postgresdb.credentials.existingSecret` now defaults to `graphrag-workflows-postgres-app`,
  tune it according to your existing database secret
- `workflows.ingress` is no longer refering to NGINX Ingress specific configurations. You can refer to the example
  in [examples/nginx-ingress](examples/nginx-ingress) on how to configure it.

