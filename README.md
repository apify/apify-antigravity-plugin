# Apify for Antigravity

Official Apify plugin for Google Antigravity. It adds the Apify MCP server, one `apify` routing agent, an always-on routing rule, and five bundled skills for the main Apify workflows: using existing Actors, building and deploying your own Actors, actorizing existing projects, generating Actor output schemas, and integrating Apify into existing applications.

> **Apify** is the largest marketplace of tools for AI: ready-made **Actors** you can run, or build your own. Find your Actor at [Apify Store](https://apify.com/store).

## What you get

| Component | Name | Purpose |
|---|---|---|
| Agent (entry point) | `apify` | Routes every Apify request to the right skill or transport path. Available in the Antigravity app and CLI. |
| Rule (always on) | `apify` | The same routing guidance for every session, including editor extensions that don't load agents. |
| MCP server | `apify` (`https://mcp.apify.com`) | Lets the agent search the Apify Store, fetch Actor details, run Actors, read results, and search the Apify docs. |
| Skill | `apify-actor-development` | Create, debug, and deploy a brand new Apify Actor from scratch. |
| Skill | `apify-actorization` | Convert an existing JS/TS, Python, or CLI project into an Apify Actor. |
| Skill | `apify-generate-output-schema` | Generate `dataset_schema.json` / `output_schema.json` / `key_value_store_schema.json` for an existing Actor. |
| Skill | `apify-sdk-integration` | Add Apify Actor execution to an existing application using the `apify-client` package. |
| Skill | `apify-ultimate-scraper` | CLI-driven data extraction workflow for selecting, configuring, and running pre-built Actors across 15+ platforms. |

## Installation

### Antigravity CLI

Requires the **Antigravity CLI** (`agy`) 1.4.0 or newer, installed and signed in.

```bash
agy plugin install https://github.com/apify/apify-antigravity-plugin
```

Confirm the install:

```bash
agy plugin list
```

The `apify` plugin should be listed as enabled with 5 skills, 1 agent, 1 rule, and 1 MCP server.

### Antigravity app

The app installs plugins from a folder. Download [`apify-antigravity-plugin.zip`](https://github.com/apify/apify-antigravity-plugin/releases/latest/download/apify-antigravity-plugin.zip) from the latest release and extract it into your global plugins folder, so the plugin ends up in `~/.gemini/config/plugins/apify`.

If you have git, you can clone the repo instead, which makes updates a `git pull`:

```bash
git clone https://github.com/apify/apify-antigravity-plugin ~/.gemini/config/plugins/apify
```

Then open **Customizations → Installed** and make sure **Apify** is enabled. To install it for a single project only, put the `apify` folder in `.agents/plugins/` inside that project instead.

For plugin management in general, see [Antigravity's plugins guide](https://antigravity.google/docs/plugins/).

### Gemini Enterprise

If your organization manages MCP servers in Gemini Enterprise, an admin may need to allow `https://mcp.apify.com` as a custom remote server. See [AI developer tools settings](https://docs.cloud.google.com/gemini/enterprise/docs/ai-developer-tools-settings).

## First-run setup

The plugin uses **three setup paths** depending on what you're doing. The `apify` agent will guide you through the right one, but here is the high-level map.

### Path 1: Using existing Actors through MCP

Uses **OAuth**. The first time Antigravity connects to the Apify MCP server, it opens `console.apify.com` in your browser and asks you to sign in. No API token goes into any config file. You can check the connection with `/mcp` in the CLI.

### Path 2: CLI workflows for Actor development, actorization, or scraper runs

These skills expect the local `apify` CLI to be available. Install it first:

```bash
npm install -g apify-cli
```

For interactive use, authenticate with:

```bash
apify login
```

In headless or CI environments, where the browser login can't open, log in with an API token instead:

```bash
apify login --token "$APIFY_TOKEN"
```

Generate a token at [console.apify.com/settings/integrations](https://console.apify.com/settings/integrations?utm_source=antigravity&utm_medium=integrations). Don't have an account? [Sign up free](https://console.apify.com/sign-up), no credit card required.

### Path 3: SDK integration into an existing application

Uses an **`APIFY_TOKEN`** environment variable with the `apify-client` package or the REST API:

```bash
export APIFY_TOKEN="apify_api_xxxxxxxxxxxx"
```

### Working in headless / SSH environments (no browser)

The MCP OAuth flow needs a browser. If you're running Antigravity over SSH or in any environment without a browser, you have these options:

1. **Authenticate locally first.** Sign in once on your laptop so the OAuth token is stored, then reconnect remotely.
2. **Use the CLI-based skills.** `apify-actor-development`, `apify-actorization`, and `apify-ultimate-scraper` can work in headless environments when the `apify` CLI is installed and logged in with `apify login --token`.
3. **Use the SDK integration skill.** `apify-sdk-integration` uses `apify-client` and only needs `APIFY_TOKEN`.

## How to use it

Describe what you need. The routing rule and the `apify` agent choose between MCP, CLI, or SDK-based workflows and dispatch to the right skill or tool. To use the agent directly, start the CLI with `agy --agent apify`, pick **apify** in the app's agent selector, or mention `@apify`.

```text
find me 5 well-rated coffee shops in Seattle and export to CSV
build me an Actor that scrapes a sitemap and stores titles
add Apify to this Next.js app so I can run a scraper from /api/scrape
generate output schemas for the Actor in this folder
```

Every skill is also a slash command, for example `/apify-ultimate-scraper`.

## Components reference

### MCP server

The `apify` MCP server is configured in `mcp_config.json`. It exposes tools such as:

- `search-actors`: search the Apify Store by keyword
- `fetch-actor-details`: Actor specs, input schema, pricing
- `call-actor`: run an Actor
- `get-actor-run`: check the status of a run
- `get-dataset-items`: retrieve dataset rows from a run
- `search-apify-docs` / `fetch-apify-docs`: Apify documentation lookup

### Bundled references

The bundled skills ship with Markdown references that the agent reads while working:

- `skills/apify-actor-development/references/`: Actor config, schemas, logging, standby mode, and README guidance
- `skills/apify-actorization/references/`: JS/TS, Python, and CLI actorization guides plus schema/output notes
- `skills/apify-ultimate-scraper/references/`: Actor index, gotchas, and workflow playbooks for common scraping use cases

The executable requirements come from the skills themselves: Route 1 uses the MCP server, Route 2 relies on the local `apify` CLI, and Route 3 uses the `apify-client` SDK.

## Data and credentials

The plugin ships only text files (Markdown, JSON, and the license) and an icon image. It has no hooks, sidecars, or scripts that Antigravity runs, so it has no code of its own that reads, stores, or sends your Apify credentials. Everything it does goes through one of the three setup paths:

| Path | What leaves your machine | Where it goes | Which credential is used |
|---|---|---|---|
| Path 1: MCP server | Your Actor searches, Actor inputs, and requests for run results and docs | `https://mcp.apify.com` | OAuth sign-in with your Apify account. Antigravity stores the OAuth token, not the plugin. |
| Path 2: Apify CLI | Commands the agent runs with your local `apify` CLI, for example Actor runs and `apify push`, which uploads your Actor's source code | Apify API | The CLI's own login from `apify login`, or `apify login --token` for headless use |
| Path 3: SDK integration | Nothing at setup. The agent writes code into your application. | Apify API, when you run your application | Your application reads `APIFY_TOKEN` from its own environment |

Also good to know:

- **Your Apify account does the work.** Actors run on the Apify platform under your account and use its credits, including paid Actors. Run results are stored in your account's datasets and key-value stores, and the results the agent asks for are returned into the conversation.
- **Usage attribution.** Actor runs started through the CLI pass `--user-agent apify-antigravity-plugin/…`, so Apify can see that a request came from this plugin. The MCP server URL has no `?client=` tag: Antigravity doesn't start the OAuth sign-in when the URL carries a query string.
- **Public docs.** To answer questions, the agent may fetch public pages such as `https://docs.apify.com/llms.txt` and Apify Store pages. No credentials are sent with these requests.

Apify processes this data under its [privacy policy](https://docs.apify.com/legal/privacy-policy).

## Troubleshooting

**Validating a local checkout.** From the repo root, run:

```bash
agy plugin validate --strict .
```

**The Apify MCP server isn't connected.** Run `/mcp` in the CLI and authenticate the Apify server, or open **Customizations** in the app and use **Authenticate** next to it. Restart the CLI after installing the plugin if the server doesn't appear.

**OAuth browser never opens / hangs.** See the "Working in headless / SSH environments" section above and switch to a CLI- or SDK-based path if needed.

**`apify` CLI not found.** Install it with `npm install -g apify-cli` before using `apify-actor-development`, `apify-actorization`, or `apify-ultimate-scraper`.

**`APIFY_TOKEN` not found.** Export `APIFY_TOKEN` in your shell before starting Antigravity when using the `apify-sdk-integration` skill. For the `apify` CLI, run `apify login --token` instead.

**The wrong skill keeps getting picked.** Use the `apify` agent (`agy --agent apify`) so the request goes through the routing table, and describe the goal explicitly: use existing Actors, build an Actor, actorize a project, generate output schemas, or integrate Apify into an app.

**`apify` vs `apify-client`.** These are two different npm packages. The `apify` package is the SDK for **building** Actors (used inside an Actor's code, on the Apify platform). The `apify-client` package is the API client for **calling** Actors from your own application. The agent picks the right one for you; if you're installing manually, double-check.

## Contributing

The skills, the `apify` agent, and the `apify` rule are generated from Apify's internal plugin source and synced here by pull request. Please open an issue in this repo for problems or suggestions; changes to generated files are made upstream, not here.

## Resources

- Apify Console: [console.apify.com](https://console.apify.com)
- Apify Store: [apify.com/store](https://apify.com/store)
- Docs (LLM-friendly): [docs.apify.com/llms.txt](https://docs.apify.com/llms.txt)
- Docs (full): [docs.apify.com/llms-full.txt](https://docs.apify.com/llms-full.txt)
- Source repo: [github.com/apify/apify-antigravity-plugin](https://github.com/apify/apify-antigravity-plugin)
- Issues / feedback: open an issue on the source repo, or email [support@apify.com](mailto:support@apify.com)

## License

Apache-2.0. See [LICENSE](./LICENSE).
