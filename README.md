# Draken Reviews

**AI-powered code review and developer intelligence.** Catch risky patterns, understand code quality, and get actionable fixes before you ship.

![Status](https://img.shields.io/badge/status-MVP-7c6cff) ![Next.js](https://img.shields.io/badge/Next.js-14-black) ![TypeScript](https://img.shields.io/badge/TypeScript-5-blue)

## What is included

- Dark developer dashboard with code editor-style input and review results.
- Review score, severity counts, and prioritized findings.
- Server-side review API with a local pattern-analysis fallback.
- Optional OpenAI-compatible chat-completions integration; provider credentials stay on the server.
- Responsive layout and Vercel-ready Next.js project structure.

## Run locally

Requirements: Node.js 20+ and npm.

```bash
git clone https://github.com/sarathbhimavarapu1-cloud/Draken-Reviews.git
cd Draken-Reviews
npm install
cp .env.example .env.local
npm run dev
```

Open http://localhost:3000. The app works without an AI key using local pattern checks. To enable live AI reviews, set `AI_API_KEY`, optionally `AI_BASE_URL` and `AI_MODEL`, in `.env.local`. Never commit `.env.local` or publish API keys.

## Deploy to Vercel

1. Import this repository at https://vercel.com/new.
2. Keep the framework preset as Next.js and the root directory as `./`.
3. Add `AI_API_KEY` (and optional `AI_BASE_URL`, `AI_MODEL`) in Project Settings → Environment Variables.
4. Deploy. The app also runs without an AI key in local-analysis mode.

## API

`POST /api/review`

```json
{ "code": "const answer = 42;", "language": "JavaScript" }
```

Returns `{ "review": { "score": 0, "summary": "...", "stats": {}, "findings": [] }, "mode": "local|ai" }`.

## Important limitations of this MVP

- Local analysis uses a few heuristic patterns; it is not a complete static analyzer and can miss vulnerabilities or flag false positives.
- The AI integration reviews pasted snippets. GitHub OAuth, repository installation, pull-request diff ingestion, persistent user accounts/history, and automated PR comments are not included yet.
- AI output is advisory. Validate findings, run tests, and require human review before applying fixes or merging code.

## Roadmap

1. GitHub OAuth / GitHub App installation and repository picker.
2. Pull request diff review with inline comments and status checks.
3. AST-based analyzers, Semgrep integration, and language-specific rules.
4. Authentication, database-backed projects and review history.
5. Exportable reports, team workspaces, and an AI assistant for follow-up questions.

## Security

Code pasted into the live AI integration is sent to the AI provider configured by the deployment operator. Do not submit secrets or proprietary code unless you have permission and understand your provider's data-handling terms. The review endpoint has request-size validation, but production deployments should add authentication, rate limiting, usage limits, and abuse monitoring before accepting public traffic.

## License

Add a license before accepting external contributions.
