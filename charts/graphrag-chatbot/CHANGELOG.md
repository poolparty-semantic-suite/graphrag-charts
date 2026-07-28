# GraphRAG Chatbot Changelog

## Version 1.2.2

### Fixed

- Added missing template handling in the `graphrag-chatbot.conversation.proxy-context-path` template function

## Version 1.2.1

### New

- Values in `configuration.properties` are now treated as Helm templates

### Updated

- Tuned the default resource requests and limits to be more appropriate for an NGINX pod

## Version 1.2.0

### New

- Updated to version v1.2.0 of the GraphRAG Chatbot application

## Version 1.1.1

### Fixed

- Added missing reference to the NGINX default.conf variable when rendering the `subPath` in the pod
- Updated the `sources` in `Chart.yaml` to point to the correct repository

## Version 1.1.0

### New

- Updated to version v1.1.0 of the GraphRAG Chatbot application

## Version 1.0.0

This is the initial release of the GraphRAG Chatbot Helm chart.
