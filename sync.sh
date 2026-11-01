#!/bin/bash
# Pull config changes from $HOME back into the repo. Run before committing.
#
# Some Omarchy commands rewrite config files with mv/sed -i (bar layout,
# text size, monitor scaling), which replaces the symlink with a plain file.
# `stow --adopt` moves such files back into the repo and relinks them;
# review the result with `git diff` (e.g. after `omarchy refresh`).

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# Packages linked on this machine (written by omarchy-install.sh)
mapfile -t packages < <(cat .stow-packages 2>/dev/null || echo omarchy)

stow --no-folding --adopt "${packages[@]}"
git status --short -- "${packages[@]}"
