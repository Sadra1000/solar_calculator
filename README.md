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

### 1. Enable Pages

**Settings → Pages → Build and deployment:**

| Setting | Value |
|---------|-------|
| Source | **GitHub Actions** |

**Settings → Actions → General → Workflow permissions:**

- Select **Read and write permissions**
- Save

> If Source is set to **Deploy from a branch (gh-pages)**, either switch to **GitHub Actions** (recommended) or revert the workflow to `peaceiris/actions-gh-pages`.

### 2. Add API key secret

**Settings → Secrets and variables → Actions → New repository secret**

| Name | Value |
|------|-------|
| `DEEPSEEK_API_KEY` | your DeepSeek API key (`sk-...`) |

### 3. Deploy

Push to `main` (or run the workflow manually from the Actions tab).

App URL: `https://<username>.github.io/<repo-name>/`

### Troubleshooting

| Symptom | Fix |
|---------|-----|
| **deploy-pages** fails with "Deployment failed, try again later" | Pages source must be **GitHub Actions** (not gh-pages branch). Re-run the workflow after saving Settings. |
| peaceiris push fails | Enable **Read and write permissions** for workflows |
| Site 404 after green workflow | Check `--base-href` matches repo name; URL is `https://<user>.github.io/<repo>/` |
| AI button errors in app | Add `DEEPSEEK_API_KEY` in Secrets |

## Security note

On web, the API key is embedded in compiled JavaScript. For a public portfolio demo:

- Use a **dedicated** DeepSeek key with spending limits
- Rotate the key if it was ever committed to git

`dart_defines.json` and `.env` are gitignored — never commit real keys.
