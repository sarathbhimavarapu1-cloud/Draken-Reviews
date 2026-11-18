# Draken Reviews

**AI-powered code review and developer intelligence.** Catch risky patterns, understand code quality, and get actionable fixes before you ship.

## Features

- Dark developer dashboard with a code editor-style input and review results
- Code health score, severity counts, and prioritized findings
- Local pattern-analysis fallback when no AI key is configured
- Optional OpenAI-compatible AI review integration (credentials stay server-side)
- GitHub App webhook integration for automatic pull-request reviews
- Inline PR comments are restricted to added lines verified against the actual diff
- CI workflow for TypeScript validation and production builds

## Tech stack

- Next.js 14 App Router, React 18, TypeScript
- Tailwind CSS 3
- Zod request validation
- OpenAI-compatible Chat Completions API
- GitHub App authentication and webhooks

## Run locally

Requirements: Node.js 20+ and npm.

```bash
git clone https://github.com/sarathbhimavarapu1-cloud/Draken-Reviews.git
cd Draken-Reviews
npm install
cp .env.example .env.local
npm run dev
```

Open http://localhost:3000. Without an AI key, pasted-code reviews use local heuristic checks. For AI reviews, set `AI_API_KEY` in `.env.local`.

## Environment variables

| Variable | Purpose |
| --- | --- |
| `AI_API_KEY` | AI provider API key |
| `AI_BASE_URL` | Optional OpenAI-compatible API base URL |
| `AI_MODEL` | Optional model name (defaults to `gpt-4o-mini`) |
| `GITHUB_APP_ID` | GitHub App ID |
| `GITHUB_APP_PRIVATE_KEY` | Full PEM private key for the GitHub App |
| `GITHUB_WEBHOOK_SECRET` | Secret configured in GitHub App webhook settings |

GitHub App setup is documented in [docs/GITHUB_APP_SETUP.md](docs/GITHUB_APP_SETUP.md). Never commit `.env.local`, private keys, or provider credentials.

## Deploy to Vercel

1. Import this repository at https://vercel.com/new.
2. Select the Next.js framework preset and root directory `./`.
3. Add the environment variables required for the features you want to enable.
4. Deploy the project.
5. Configure the GitHub App webhook URL as `https://YOUR-DOMAIN/api/github/webhook`.

The application can run pasted-code local analysis without external credentials. Live AI and automated GitHub PR reviews require the corresponding server-side credentials.

## GitHub pull-request reviews

Install a GitHub App on the repositories you want Draken to review. For `opened`, `synchronize`, `reopened`, and `ready_for_review` pull-request events, the webhook:

1. Verifies GitHub's HMAC SHA-256 webhook signature.
2. Creates a short-lived installation access token using the GitHub App private key.
3. Fetches the pull-request diff.
4. Sends the diff to the configured AI provider.
5. Validates proposed inline comments against added lines in the diff.
6. Posts a normal GitHub PR review with a summary and eligible inline comments.

Draken only posts comments. It does not approve, request changes, merge, or modify repository files.

## Current limitations

- The UI currently supports pasted snippets. The GitHub App webhook provides the automated PR-review path once deployed and configured.
- Local analysis is a small set of heuristics, not a complete static analyzer.
- Review history, user accounts, team workspaces, and repository browsing inside the dashboard are not implemented yet.
- Production deployments should add authentication, rate limiting, usage controls, and abuse monitoring before accepting public traffic.
- AI output is advisory. Validate findings with tests and human review.

## Security

The AI provider receives code snippets or pull-request diffs submitted for AI review. Confirm your source-code and provider data-handling policies before use. Install the GitHub App only on repositories you intend to review, and keep all credentials in server-side environment variables.

See [SECURITY.md](SECURITY.md) for reporting guidance.
