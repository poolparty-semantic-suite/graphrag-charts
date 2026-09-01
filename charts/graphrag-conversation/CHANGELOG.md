# GraphRAG Conversation Changelog

## Version 1.4.0

### New

- Added explicit `configuration.duckdb` configuration section for specifying the credentials for the DuckDB database
- Added explicit `configuration.keycloak` configuration section for specifying the client credentials for the Keycloak
  instance

## Updated

- Added Apache 2.0 license to be packaged with the chart
- Added `spring.security.oauth2.client.registration.keycloak.scope` with `openid` as a default configuration value
- Added `spring.security.oauth2.client.registration.keycloak.client-id` with `graphrag-conversation` as a default
  configuration value

## Version 1.3.0

### New

- Updated to version 1.3.0 of the GraphRAG Conversation service

## Version 1.2.1

### New

- Values in `configuration.properties` are now treated as Helm templates

## Version 1.2.0

### Updated

- Updated to version 1.2.0 of the GraphRAG Conversation service

## Version 1.1.1

### Fixed

- Removed default Java arguments from defaultJavaArguments that might disrupt the service operation
- Updated the `sources` in `Chart.yaml` to point to the correct repository

## Version 1.1.0

### Updated

- Updated to version 1.1.0 of the GraphRAG Conversation service

## Version 1.0.0

This is the initial release of the GraphRAG Conversation Helm chart.
