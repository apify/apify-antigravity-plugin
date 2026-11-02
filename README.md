# Apify for Antigravity

Official Apify plugin for Google Antigravity. Ask for web data in plain language and the agent runs ready-made scrapers and automation tools (Actors) from [Apify Store](https://apify.com/store), or helps you build and publish your own.

## Quick start

1. Install the plugin (see [Installation](#installation)).
1. Sign in to Apify. In the Antigravity CLI, run `/mcp` and authenticate the Apify server. In the app, open **Customizations → Installed → Apify** and select **Sign in** on the **Accounts** tab. Antigravity opens your browser for the Apify sign-in; no API token goes into any config file.
1. Ask for something:

    ```text
    find me 5 well-rated coffee shops in Seattle and export to CSV
    ```

    The agent searches Apify Store, picks an Actor, runs it, and returns the results. If that works, the plugin is set up.

## Installation

### Antigravity CLI

Requires the [**Antigravity CLI**](https://antigravity.google/download) (`agy`) 1.4.0 or newer, installed and signed in.

```bash
agy plugin install https://github.com/apify/apify-antigravity-plugin
```

You can also install from the [release ZIP](https://github.com/apify/apify-antigravity-plugin/releases/latest/download/apify-antigravity-plugin.zip): extract it into `~/.gemini/config/plugins` as described for the app below. The CLI and the app share that folder.

### Antigravity App

The [Antigravity App](https://antigravity.google/download) installs plugins from a folder. Download [`apify-antigravity-plugin.zip`](https://github.com/apify/apify-antigravity-plugin/releases/latest/download/apify-antigravity-plugin.zip) from the latest release and extract it into your global plugins folder, so the plugin ends up in `~/.gemini/config/plugins/apify`.

If you have git, you can clone the repo instead, which makes updates a `git pull`:

```bash
git clone https://github.com/apify/apify-antigravity-plugin ~/.gemini/config/plugins/apify
```

Then open **Customizations → Installed** and check that **Apify** is listed. To install it for a single project only, put the `apify` folder in `.agents/plugins/` inside that project instead.

These are the default plugin folders at the time of writing. If **Apify** doesn't show up, check the current locations in [Antigravity's plugins guide](https://antigravity.google/docs/plugins).

Using Gemini Enterprise with managed MCP servers? An admin may need to allow `https://mcp.apify.com`; see [AI developer tools settings](https://docs.cloud.google.com/gemini/enterprise/docs/ai-developer-tools-settings).

## What you can ask for

```text
find me 5 well-rated coffee shops in Seattle and export to CSV
build me an Actor that scrapes a sitemap and stores titles
turn this Python script into an Apify Actor
add Apify to this Next.js app so I can run a scraper from /api/scrape
generate output schemas for the Actor in this folder
```

Requests are routed automatically. To talk to the Apify agent directly, start the CLI with `agy --agent apify`, pick **apify** in the app's agent selector, or mention `@apify`.

| Skill | What it does |
|---|---|
| `/apify-ultimate-scraper` | Find, configure, and run ready-made Actors for 15+ platforms such as Google Maps, Instagram, and TikTok. |
| `/apify-actor-development` | Create, debug, and deploy a new Actor from scratch. |
| `/apify-actorization` | Turn an existing JavaScript, TypeScript, Python, or command-line project into an Actor. |
| `/apify-generate-output-schema` | Generate output schemas for an existing Actor. |
| `/apify-sdk-integration` | Add Actor runs to your own application with the `apify-client` package. |

The plugin also adds the Apify MCP server (`https://mcp.apify.com`), the `apify` agent, and an always-on `apify` rule that does the routing.

## Building Actors and app integrations

Running existing Actors only needs the sign-in from the [Quick start](#quick-start). Two other jobs need extra setup:

- **Building or deploying Actors** (`apify-actor-development`, `apify-actorization`) and CLI scraper runs use the Apify CLI:

    ```bash
    npm install -g apify-cli
    apify login
    ```

    Where the browser login can't open, such as over SSH, use `apify login --token "$APIFY_TOKEN"` instead.

- **Integrating Apify into your app** (`apify-sdk-integration`): your application reads `APIFY_TOKEN` from its environment. Note that `apify-client` is the package for calling Actors from your app; `apify` is the SDK for code that runs inside an Actor.

    ```bash
    export APIFY_TOKEN="apify_api_xxxxxxxxxxxx"
    ```

Get an API token at [console.apify.com/settings/integrations](https://console.apify.com/settings/integrations?utm_source=antigravity&utm_medium=integrations), or [sign up free](https://console.apify.com/sign-up).

## Data and credentials

The plugin is text files and an icon. It has no hooks, sidecars, or scripts that Antigravity runs, so no code of its own touches your credentials.

| Path | What leaves your machine | Where it goes | Which credential is used |
|---|---|---|---|
| Apify MCP server | Your Actor searches, Actor inputs, and requests for run results and docs | `https://mcp.apify.com` | OAuth sign-in with your Apify account. Antigravity stores the OAuth token, not the plugin. |
| Apify CLI | Commands the agent runs with your local Apify CLI, for example Actor runs and `apify push`, which uploads your Actor's source code | The Apify API | The Apify CLI's own login from `apify login` or `apify login --token` |
| SDK integration | Nothing at setup. The agent writes code into your application. | The Apify API, when you run your application | Your application reads `APIFY_TOKEN` from its own environment |

Actor runs started through the Apify CLI identify themselves as coming from this plugin, so Apify can measure its usage. Apify processes this data under its [privacy policy](https://docs.apify.com/legal/privacy-policy).

## Troubleshooting

**The Apify MCP server isn't connected.** Sign in as described in the [Quick start](#quick-start). Restart Antigravity after installing the plugin if the server doesn't appear.

**The sign-in browser never opens or hangs.** You're likely in an environment without a browser. Sign in once on a machine that has one, or use the Apify CLI with `apify login --token` (see [Building Actors and app integrations](#building-actors-and-app-integrations)).

**`apify` command not found.** Install the Apify CLI with `npm install -g apify-cli`.

**`APIFY_TOKEN` not found.** Export `APIFY_TOKEN` in your shell before starting Antigravity when your app uses `apify-client`. For the Apify CLI, run `apify login --token` instead.

**The wrong skill keeps getting picked.** Use the `apify` agent (`agy --agent apify`) and say what you want explicitly: run an existing Actor, build an Actor, turn a project into an Actor, generate output schemas, or add Apify to an app.

## Contributing

The skills, the `apify` agent, and the `apify` rule are generated from Apify's internal plugin source and synced here by pull request, so changes to them are made upstream. Please open an [issue in this repo](https://github.com/apify/apify-antigravity-plugin/issues) for problems or suggestions.

To validate a local checkout, run `agy plugin validate --strict .` from the repo root. The plugin follows the [Agent Plugins](https://agent-plugins.org/) spec and also ships Antigravity's native `mcp_config.json`, so it loads either way. Keep the MCP server URL in `mcp.json` and `mcp_config.json` identical and free of query strings such as `?client=`: Antigravity doesn't start the OAuth sign-in when the URL has one. Maintainers: see [RELEASE.md](RELEASE.md).

## Resources

- What changed: [CHANGELOG.md](CHANGELOG.md) and [Releases](https://github.com/apify/apify-antigravity-plugin/releases)
- Apify Console: [console.apify.com](https://console.apify.com)
- Apify Store: [apify.com/store](https://apify.com/store)
- Apify docs: [docs.apify.com](https://docs.apify.com)
- Support: open an [issue in this repo](https://github.com/apify/apify-antigravity-plugin/issues), or email [support@apify.com](mailto:support@apify.com)

## License

Apache-2.0. See [LICENSE](./LICENSE).
