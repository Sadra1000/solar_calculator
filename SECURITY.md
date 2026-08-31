# Security

## API keys

Never place a provider API key in a public web build. This project uses a platform-specific credential source so `DEEPSEEK_API_KEY` is ignored by Flutter Web. Public deployments may enable AI only through the HTTPS endpoint configured in `DEEPSEEK_PROXY_URL`.

The proxy must keep the provider key server-side, restrict allowed origins, validate request size, and enforce rate limits.

## Reporting an issue

Please report suspected credential exposure or another security issue privately to the repository owner instead of opening a public issue with sensitive details.
