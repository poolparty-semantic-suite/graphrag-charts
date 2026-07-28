# GraphRAG Workflows Changelog

## Version 1.2.1

### New

- Values in `configuration.environment` are now treated as Helm templates
- Added `configuration.license.optional` to instruct Kubernetes if it should expect the license secret or not

## Version 1.2.0

### New

- Updated to version v1.2.0 of the GraphRAG Workflows engine
- Added default values for `N8N_WORKFLOW_OVERWRITE_DATATABLE_ID`, `N8N_WORKFLOW_OVERWRITE_PARALLEL_DATATABLE_ID` and
  `N8N_WORKFLOW_OVERWRITE_SIMPLECACHE_DATATABLE_ID` environment variables

## Version 1.1.1

### Fixed

- Updated the `sources` in `Chart.yaml` to point to the correct repository

## Version 1.1.0

### New

- Updated to version v1.1.0 of the GraphRAG Workflows engine

## Version 1.0.0

This is the initial release of the GraphRAG n8n Helm chart.
