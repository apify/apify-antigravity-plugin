# Releasing

## What lives where

| Path | Owner | Notes |
|---|---|---|
| `skills/`, `agents/apify.md`, `rules/apify.md` | Generated in `apify-plugins-internal`, synced here by `apify-plugins-bot` PRs | Don't edit here; the next sync overwrites the change. The sync never deletes files, so remove renamed or deleted files by hand |
| `plugin.json`, `mcp_config.json`, `assets/`, `README.md`, `CHANGELOG.md`, `LICENSE`, `RELEASE.md`, `.github/` | This repo | Edited directly through PRs |

The version lives in `plugin.json` (`version`) and in the Git tag. Antigravity shows it in `agy plugin list` and on the plugin's page. Don't edit `version` or `CHANGELOG.md` by hand: the release workflow writes both.

## Releasing a new version

Releases are push-button. `release.yml` uses [git-cliff](https://git-cliff.org/) to derive the version and changelog from Conventional Commit titles (`feat:`, `fix:`, `chore:`, …), so give every PR a conventional title and squash-merge it. Sync PRs from `apify-plugins-internal` reuse the source PR's conventional title.

1. Merge the changes to `main`. Git-URL installs pick up `main` the next time a user installs.
2. Actions → **Create a release** → **Run workflow** on `main`, with `release_type`:
   - `auto`: version from the commits since the last tag (`feat` → minor, `fix` → patch, `!` → major)
   - `patch` / `minor` / `major`: force the bump
   - `custom` + `custom_version`: an explicit version. **The first release must be `custom` with `v1.0.0`**, because `auto` needs a prior tag.
3. The workflow sets `version` in `plugin.json`, rewrites `CHANGELOG.md`, pushes `chore(release): X.Y.Z [skip ci]` to `main` as `apify-plugins-bot`, creates the `vX.Y.Z` GitHub Release with the notes, and attaches `apify-antigravity-plugin.zip` (the plugin files under `apify/`) for app users who install without git.

To change the release type after a failed run, start a new **Run workflow**. **Re-run jobs** replays the original inputs.

**Repo prerequisites:** the `APIFY_SERVICE_ACCOUNT_GITHUB_TOKEN` secret is available to this repo, and its account may push to `main` (allowed to bypass branch protection if `main` is protected).

Versioning: patch for content fixes and docs, minor for new skills or capabilities, major for removed or renamed skills (their `/apify-*` commands change) or a changed install path.
