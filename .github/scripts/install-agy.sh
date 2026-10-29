#!/usr/bin/env bash
# Installs the Antigravity CLI (agy) for the validate workflow, using the official
# installer from https://github.com/google-antigravity/antigravity-cli#installation.
# The installer downloads the latest build to ~/.local/bin and verifies its SHA-512
# against Google's release manifest. It has no version flag, so CI always runs the
# newest agy (tested with 1.4.8); a new release can change strict-mode results.
# `agy plugin validate` needs no Google sign-in.
set -euo pipefail

curl -fsSL https://antigravity.google/cli/install.sh | bash

export PATH="$HOME/.local/bin:$PATH"
if [ -n "${GITHUB_PATH:-}" ]; then
  echo "$HOME/.local/bin" >> "$GITHUB_PATH"
fi

agy --version
