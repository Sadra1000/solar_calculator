# Solar Calculator | ماشین‌حساب خورشیدی

A bilingual Flutter web app for estimating household electricity consumption and planning a preliminary solar setup for major Iranian cities.

**Live demo:** [sadra1000.github.io/solar_calculator](https://sadra1000.github.io/solar_calculator/)

## What it does

- Calculates daily, monthly, and yearly electricity consumption from selected appliances.
- Estimates electricity cost using a user-editable Toman/kWh rate.
- Suggests panel count, solar-array capacity, a standard inverter size, and nominal one-day battery capacity.
- Accounts for city-level solar resource, connected peak load, system losses, battery depth of discharge, and an inverter safety margin.
- Shows appliance-level consumption charts and estimated grid-related CO₂ emissions.
- Saves the latest calculations locally and lets users reopen or share them.
- Supports Persian and English, light and dark themes, mobile, desktop, and installable PWA layouts.
- Produces a deterministic local recommendation without requiring an account or API key.
- Can optionally add DeepSeek analysis directly or through an OpenAI-compatible server-side proxy.

## Product boundaries

This app is a planning estimator, not an engineering design tool. Roof area, shading, panel orientation, seasonal generation, cable sizing, protection equipment, local grid rules, structural checks, and installer quotations must be verified on site by a qualified professional.

Equipment prices are scenario assumptions for early planning, not vendor quotes. The exchange rate is refreshed when available and falls back to a documented local value when offline.

## Calculation basis

- Appliance energy: `power (W) × operating hours ÷ 1000`
- Solar array: `daily kWh ÷ (city irradiance × 0.78 performance ratio)`
- Inverter: next standard size above `max(array kW, connected load kW) × 1.15`
- Nominal battery: `daily kWh ÷ (0.80 depth of discharge × 0.90 system efficiency)`
- Grid emissions: `0.494 kg CO₂/kWh`, based on Ember's reported 2022 Iran electricity intensity

Reference datasets and methodology:

- [World Bank / Global Solar Atlas solar-resource datasets](https://datacatalog.worldbank.org/search/dataset/0038640/world-high-resolution-solar-resource-ghi-dif-gti-dni-gis-data-global-solar-atlas)
- [Ember Global Electricity Review — Iran electricity intensity](https://ember-energy.org/app/uploads/2024/11/Global-Electricity-Review-2023.pdf)
- [USD/Toman rate-json dataset](https://github.com/rate-json/default)

## Run locally

Requirements: Flutter `3.47.1` and Dart `3.13.x`.

```bash
flutter pub get
flutter run -d chrome
```

The calculator and local recommendation work without configuration.

For optional DeepSeek analysis, copy `dart_defines.example.json` to the gitignored `dart_defines.json`.

Native/local builds may use a provider key directly:

```json
{
  "DEEPSEEK_API_KEY": "sk-your-key-here",
  "DEEPSEEK_MODEL": "deepseek-v4-flash"
}
```

Then run:

```bash
flutter run --dart-define-from-file=dart_defines.json
```

## Secure AI configuration for public web builds

When the `DEEPSEEK_API_KEY` GitHub Secret is configured, the portfolio deployment injects it into the Flutter Web build so DeepSeek works directly in the browser. This makes the key readable from the downloadable JavaScript and should only be used with a disposable, quota-limited key.

For a production deployment, configure `DEEPSEEK_PROXY_URL` with the full HTTPS URL of an OpenAI-compatible `/chat/completions` proxy instead. The proxy is responsible for adding the provider authorization header, restricting allowed origins, and applying rate limits.

For GitHub Pages, add `DEEPSEEK_PROXY_URL` under **Settings → Secrets and variables → Actions → Variables**. If it is absent, the deployed app remains fully usable and shows its local recommendation.

## Quality checks

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
flutter build web --release --no-pub --base-href=/solar_calculator/
```

The GitHub Actions workflow pins Flutter, checks formatting, analyzes, runs the core tests, builds the release bundle, and deploys it to GitHub Pages.

## Technology

Flutter, Dart, Bloc/Cubit, go_router, Dio, get_it, SharedPreferences, Syncfusion Charts, GitHub Actions, and GitHub Pages.
