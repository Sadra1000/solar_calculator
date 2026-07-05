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
| Source | **Deploy from a branch** |
| Branch | **gh-pages** / **/(root)** |

**Settings → Actions → General → Workflow permissions:**

- Select **Read and write permissions**
- Save

> If Source is set to **GitHub Actions**, deployments will fail. Switch to **gh-pages** branch.

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
| Deployments tab shows red **Failed to deploy to github-pages** | Old `deploy-pages` runs — ignore after switching workflow; re-run **Deploy Flutter Web** from Actions |
| peaceiris push fails | Enable **Read and write permissions** for workflows |
| Site 404 after green workflow | Pages source must be **gh-pages** branch, not GitHub Actions |
| AI button errors in app | Add `DEEPSEEK_API_KEY` in Secrets |

## Security note

On web, the API key is embedded in compiled JavaScript. For a public portfolio demo:

- Use a **dedicated** DeepSeek key with spending limits
- Rotate the key if it was ever committed to git

`dart_defines.json` and `.env` are gitignored — never commit real keys.
