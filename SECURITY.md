# Security

## API keys

The public portfolio build currently supports direct `DEEPSEEK_API_KEY` injection by explicit project-owner choice. Flutter Web embeds dart-define values in downloadable JavaScript, so this key must be treated as public, disposable, and quota-limited.

Production deployments should use `DEEPSEEK_PROXY_URL`. The proxy must keep the provider key server-side, restrict allowed origins, validate request size, and enforce rate limits.

## Reporting an issue

Please report suspected credential exposure or another security issue privately to the repository owner instead of opening a public issue with sensitive details.
