# Draken Reviews

**A free, open-source, local-first AI code review workspace.** Draken sends source code directly from your browser to [Ollama](https://ollama.com/) on your computer. No paid AI API, hosted database, or application server is required.

## Features

- Local AI code review and corrected-code generation using Ollama
- Configurable Ollama URL and model name in the dashboard
- Public GitHub pull-request diff review (paste a public PR URL)
- Severity-ranked findings, code quality score, and suggested fixes
- Review history saved in your browser's local storage
- Static website deployment to GitHub Pages through GitHub Actions

## Free stack

- Next.js, React, TypeScript, Tailwind CSS
- [Ollama](https://ollama.com/) for local inference
- [Qwen2.5-Coder](https://ollama.com/library/qwen2.5-coder) as the suggested coding model
- Git and GitHub for source control and hosting
- GitHub Actions for automated build and deployment

## Run locally

Requirements: Node.js 20+, npm, and Ollama.

```bash
git clone https://github.com/sarathbhimavarapu1-cloud/Draken-Reviews.git
cd Draken-Reviews
npm install
ollama pull qwen2.5-coder:7b
ollama serve
```

In another terminal:

```bash
npm run dev
```

Open http://localhost:3000. In the dashboard, keep the Ollama URL as `http://localhost:11434` and model as `qwen2.5-coder:7b` (or enter a model you have pulled).

### Allow browser access to Ollama

Ollama must allow requests from the website origin. For local development, include `http://localhost:3000` in `OLLAMA_ORIGINS`. For the deployed site, also include `https://sarathbhimavarapu1-cloud.github.io`.

On Windows, set the variable in the environment used by the Ollama application, then restart Ollama:

```powershell
[Environment]::SetEnvironmentVariable('OLLAMA_ORIGINS','http://localhost:3000,https://sarathbhimavarapu1-cloud.github.io','User')
```

On macOS/Linux, configure `OLLAMA_ORIGINS` for the Ollama service before starting it. See the [Ollama FAQ](https://github.com/ollama/ollama/blob/main/docs/faq.md) for platform-specific instructions.

If the browser blocks the request, check that Ollama is running, the model is installed, and the exact site origin is allowed. Do not expose Ollama's port to the public internet.

## Deploy free with GitHub Pages

1. Open repository **Settings → Pages**.
2. Under **Build and deployment → Source**, select **GitHub Actions**.
3. Push a commit to `main` (or run the workflow manually under **Actions**).
4. After the workflow succeeds, the site will be available at:
   `https://sarathbhimavarapu1-cloud.github.io/Draken-Reviews/`

The workflow builds and deploys the static frontend. Ollama remains on each user's computer, so visitors need their own Ollama installation and model. No paid inference or server hosting is required.

## Review a GitHub pull request

Select **GitHub pull request** in the source dropdown and paste a public pull-request URL such as `https://github.com/owner/repository/pull/123`. Draken retrieves the public diff through GitHub's API and analyzes it locally with Ollama. Private repositories are not supported in this static, credential-free version. Draken does not automatically post GitHub comments.

## Privacy and limitations

- Pasted code and fix requests are sent directly from the browser to the Ollama URL you configure; Draken does not relay them through a Draken server.
- Public PR diffs are downloaded from GitHub, then analyzed locally.
- Review history is stored only in the current browser profile.
- AI output can be incorrect. Inspect findings and generated fixes and run tests before merging.
- Model quality and speed depend on your hardware. A 7B model may need several GB of RAM; smaller models may suit lower-spec devices.
- GitHub Pages cannot run Next.js API routes or host Ollama. Automatic webhook reviews, private repository access, shared accounts, and cloud history are intentionally excluded from this free static version.

## Security

Never expose your Ollama port to the public internet. Allow only trusted browser origins in `OLLAMA_ORIGINS`. Do not submit secrets or proprietary code unless your policies permit it.

## License

MIT. See [LICENSE](LICENSE) if included in this repository.
