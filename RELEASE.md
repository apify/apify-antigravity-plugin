# Releasing

Runbook for maintainers cutting a release. For what changed in each version, see [CHANGELOG.md](CHANGELOG.md) or the [Releases](https://github.com/apify/apify-antigravity-plugin/releases) page.

## What lives where

| Path | Owner | Notes |
|---|---|---|
| `skills/`, `agents/apify.md`, `rules/apify.md` | Generated in `apify-plugins-internal`, synced here by `apify-plugins-bot` PRs | Don't edit here; the next sync overwrites the change. The sync never deletes files, so remove renamed or deleted files by hand |
| `plugin.json`, `mcp.json`, `mcp_config.json`, `assets/`, `README.md`, `CHANGELOG.md`, `LICENSE`, `RELEASE.md`, `.github/` | This repo | |

Don't edit `version` in `plugin.json` or `CHANGELOG.md` by hand: the release workflow writes both.

## Why two MCP files

`mcp.json` ([Agent Plugins spec](https://agent-plugins.org/specification), which Google asked partners to follow) and `mcp_config.json` (native Antigravity, the only file in [Google's plugin docs](https://antigravity.google/docs/build-plugins)) describe the same MCP server. agy reads exactly one of them, depending on its `enable-agent-plugins-spec` flag:

- Flag off (the default as of agy 1.4.12): only `mcp_config.json` is read. With `mcp.json` alone, the plugin installs without the Apify MCP server.
- Flag on: only `mcp.json` is read; `mcp_config.json` is ignored.

Keep both, with the same bare URL; `validate.yml` checks that. Once spec mode is agy's default, delete `mcp_config.json` and its `validate.yml` check. The same applies to `displayName`, `logo`, and `suggestedPrompts` in `plugin.json`: they're outside the spec's manifest fields, but agy needs them for the Marketplace listing.

## Release

1. Merge to `main` with conventional, squash-merged PR titles (`feat:`, `fix:`, …). Sync PRs keep the source PR's title.
2. Actions → **Create a release** → **Run workflow** on `main`:
   - `auto`: bump from the commits since the last tag. Removing or renaming a skill is a major bump, since its `/apify-*` command changes.
   - `patch` / `minor` / `major`: force the bump.
   - `custom` + `custom_version`: use this for the first release, with `v1.0.0`. `plugin.json` already says `1.0.0`; the run creates the tag and changelog, which `auto` can't do without a prior tag.
3. The workflow bumps `plugin.json` and `CHANGELOG.md`, tags `vX.Y.Z`, and attaches `apify-antigravity-plugin.zip`. It stops before any of that if the synced skills, agent, or rule are missing.

Requires the `APIFY_SERVICE_ACCOUNT_GITHUB_TOKEN` secret, with push access to `main`.
