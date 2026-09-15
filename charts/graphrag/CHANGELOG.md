# GraphRAG Changelog

## Version 2.0.1

### Updated

- Updated the Conversation service to chart version 1.4.1

### Fixed

- Updated the `n8n.chat.webhook.url` property of the Conversation service to include the `custom` query param as well.

## Version 2.0.0

### Breaking Changes

Beginning with 2.0.0, we have replaced the GraphRAG Workflows Helm chart with a new generic Graphwise Workflows Helm
chart. Refer to the [Upgrade guide for 2.0.0](UPGRADE.md#200) for more details and migration steps.

### New

- Added Apache 2.0 license to be packaged with the chart.
- Added documentation notes and references in the [values.yaml](values.yaml) file.
- Added `global.graphragh` section with common configuration variables that are used across the subcharts via Helm
  templates.
- Conversation service credentials for DuckDB and Keycloak are now configured with the new explicit
  `conversation.configuration.duckdb` and `conversation.configuration.keycloak` configurations respectively.
- Enabled the Workflows bootstrap by running a Helm hook that provisions the database with a baseline of workflows.

### Updated

- Major overhaul of the chart documentation, README.md and examples under [examples/](examples).

## Version 1.3.0

### Updated

- Updated the subcharts to version 1.3.0 of GraphRAG. Check their respective `CHANGELOG.md` files for more details.

## Version 1.2.2

### Updated

- Updated the chatbot subchart to version 1.2.2. Check its respective `CHANGELOG.md` files for more details.

## Version 1.2.1

### Updated

- Updated all subcharts to their latest versions. Check their respective `CHANGELOG.md` files for more details.

## Version 1.2.0

### Updated

- Updated to GraphRAG 1.2.0

## Version 1.1.1

### Fixed

- Extracted secret references from `values.yaml` to `values.example.yaml` to avoid configuration issues
- Updated the `sources` in `Chart.yaml` to point to the correct repository
- Updated dependencies to their latest versions

## Version 1.1.0

### New

- Updated to GraphRAG 1.1.0

## Version 1.0.0

Official release of GraphRAG and its Helm charts.

## Version 0.1.0

This is the initial release of the GraphRAG umbrella Helm chart.
