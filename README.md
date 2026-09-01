# Graphwise GraphRAG Helm Charts

This repository contains the Helm charts suite for deploying GraphRAG by Graphwise.

## Quickstart

```
helm repo add graphwise-graphrag https://poolparty-semantic-suite.github.io/graphrag-charts
helm repo update graphwise-graphrag
```

Follow the further instructions in the [README.md](charts/graphrag/README.md) of the umbrella `charts/graphrag/` Helm
chart.

## About Graphwise

<p align="center">
  <a href="https://graphwise.ai/">
    <picture>
      <img src="https://graphwise.ai/wp-content/uploads/2024/10/graphwise-logo-horizontal-slogan.svg" alt="Graphwise logo" title="Graphwise" height="75">
    </picture>
  </a>
</p>

Graphwise brings confidence to search, analytics, and AI. Our platform is built for enterprises where precision is a
must or complexity is high. We transform disparate data silos into a trusted enterprise knowledge graph, providing a
governed layer of context for consistent, reliable AI applications. At Graphwise, we turn enterprise data from a
liability into an asset. We build the “trusted semantic backbone” that connects disconnected data silos and integrates
your proprietary domain knowledge into your AI. This allows you to govern your AI , boost model accuracy , and drive a
positive ROI.

## Structure

The Helm deployment for GraphRAG consists of the following Helm charts:

- [charts/graphrag/](charts/graphrag) - Umbrella Helm chart for deploying the GraphRAG suite
- [charts/graphrag-chatbot/](charts/graphrag-chatbot) - Helm chart for deploying the Chatbot web application
- [charts/graphrag-components/](charts/graphrag-components) - Helm chart for deploying the Components service for
  vectors searches
- [charts/graphrag-conversation/](charts/graphrag-conversation) - Helm chart for deploying the Conversation service

## License

This code is released under the Apache 2.0 License. See [LICENSE](LICENSE) for more details.
