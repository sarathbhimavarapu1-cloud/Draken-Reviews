# Connect Draken Reviews to GitHub

Draken can automatically review pull requests after a GitHub App is installed on a repository. The webhook integration is implemented at `/api/github/webhook`.

## 1. Deploy the web app first

Deploy the Next.js app to a public HTTPS host (Vercel is supported). You need the final domain before configuring the GitHub App webhook.

## 2. Create a GitHub App

Open **GitHub → Settings → Developer settings → GitHub Apps → New GitHub App**.

Suggested configuration:

- GitHub App name: `Draken Reviews`
- Homepage URL: your deployed Draken Reviews URL
- Webhook URL: `https://YOUR-DOMAIN/api/github/webhook`
- Webhook secret: generate a long random secret and save it securely
- Subscribe to events: **Pull request**
- Repository permissions:
  - **Contents: Read-only**
  - **Pull requests: Read and write**
  - **Metadata: Read-only** (automatically required)

Create the app, generate a private key, and install the app on the repositories you want Draken to review.

## 3. Configure deployment environment variables

Set these in your hosting provider's server-side environment variable settings:

| Variable | Value |
| --- | --- |
| `GITHUB_APP_ID` | App ID shown on the GitHub App settings page |
| `GITHUB_APP_PRIVATE_KEY` | Entire downloaded PEM private key |
| `GITHUB_WEBHOOK_SECRET` | The webhook secret you chose |
| `AI_API_KEY` | Your AI provider API key |
| `AI_BASE_URL` | Optional; defaults to `https://api.openai.com/v1` |
| `AI_MODEL` | Optional; defaults to `gpt-4o-mini` |

For the private key, paste the full PEM value. The integration also accepts escaped newline characters. Never put these values in source files or commit them.

## 4. Verify the webhook

Visit `https://YOUR-DOMAIN/api/github/webhook`. It should return JSON with `configured: true` after all four required secrets are configured.

In GitHub App settings, use **Redeliver** on a test webhook delivery if needed. Open a pull request in an installed repository. On `opened`, `synchronize`, `reopened`, or `ready_for_review`, Draken fetches the diff, requests an AI review, and posts a GitHub pull-request review with validated inline comments on added lines.

## Permissions and safety

- Draken posts review comments; it does not approve, request changes, merge, or modify source code.
- Inline comments are only attached to added lines that exist in the actual diff.
- The AI provider receives the pull request diff. Confirm your organization's source-code and provider data policies before installing the app.
- Use a dedicated GitHub App and grant access only to repositories you intend to review.
