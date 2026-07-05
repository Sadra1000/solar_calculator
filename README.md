# Solar Calculator

Flutter web app for estimating daily household electricity use and getting AI-powered solar advice via DeepSeek — **no backend server required**.

## API key setup

The app calls DeepSeek directly. The key is injected at build time (not stored in source code).

| Environment | How |
|-------------|-----|
| Local | Copy `dart_defines.example.json` → `dart_defines.json` and add your key |
| GitHub Actions | Repository secret `DEEPSEEK_API_KEY` |

```bash
cp dart_defines.example.json dart_defines.json
# edit dart_defines.json, then:
flutter run -d chrome --dart-define-from-file=dart_defines.json
```

Or launch **Flutter (Chrome)** from VS Code (uses `dart_defines.json`).

## GitHub Pages (free hosting)

1. **Settings → Pages → Source: GitHub Actions**
2. Add secret **`DEEPSEEK_API_KEY`** with your DeepSeek API key
3. Push to `main`

App URL: `https://<username>.github.io/<repo-name>/`

## Security note

On web, the API key is embedded in compiled JavaScript. For a public portfolio demo:

- Use a **dedicated** DeepSeek key with spending limits
- Rotate the key if it was ever committed to git

`dart_defines.json` and `.env` are gitignored — never commit real keys.
