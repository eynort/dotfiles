#!/bin/bash
# Turn a fresh Omarchy install into my setup.
#
#   ./omarchy-install.sh            # laptop / any machine
#   ./omarchy-install.sh --desktop  # also link desktop-only config (monitors)
#
# Safe to re-run. Can be run from anywhere (e.g. ~/Downloads/dotfiles): the
# repo is moved to ~/dotfiles first, since every config symlink points there.

set -euo pipefail

DOTFILES="$HOME/dotfiles"
THEME="vantablack"
BACKGROUND="3-layers-stacked.jpg"
USER_UNITS=(voxtype.service oomd-notify.service codex-chromium.service)

src=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
packages=(omarchy)
[[ ${1:-} == --desktop ]] && packages+=(omarchy-desktop)

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

if ! command -v omarchy >/dev/null; then
  echo "This script is meant for Omarchy (https://omarchy.org)." >&2
  exit 1
fi

if [[ $src != "$DOTFILES" ]]; then
  if [[ -e $DOTFILES ]]; then
    echo "$DOTFILES already exists; run the script from there instead." >&2
    exit 1
  fi
  # Move rather than copy, so there is only one checkout to edit and commit
  step "Moving repo from $src to $DOTFILES"
  mv "$src" "$DOTFILES"
  exec "$DOTFILES/omarchy-install.sh" "$@"
fi

omarchy sudo keepalive

step "Installing packages"
mapfile -t repo < <(grep -vE '^\s*(#|$)|^aur:' "$DOTFILES/omarchy-packages.txt")
mapfile -t aur < <(sed -n 's/^aur://p' "$DOTFILES/omarchy-packages.txt")
omarchy pkg add stow "${repo[@]}"
if (( ${#aur[@]} )); then omarchy pkg aur add "${aur[@]}"; fi

# Omarchy installers write their own default config, so run them before
# linking; the repo version replaces those defaults below.
step "Running Omarchy installers"
command -v steam >/dev/null || omarchy install gaming steam
command -v voxtype >/dev/null || omarchy-voxtype-install

step "Linking config (stow)"
cd "$DOTFILES"
# --adopt moves the stock files Omarchy shipped into the repo so stow can
# link over them; on the first run git checkout then puts the repo version
# back. Later runs keep local edits (sync.sh adopts them the same way).
first_run=false
[[ -f .stow-packages ]] || first_run=true
stow --no-folding --adopt "${packages[@]}"
$first_run && git checkout -- "${packages[@]}"
printf '%s\n' "${packages[@]}" >.stow-packages

step "Enabling user services"
systemctl --user daemon-reload
systemctl --user enable --now "${USER_UNITS[@]}" || true

step "Applying theme"
omarchy theme set "$THEME"
omarchy theme bg set "${OMARCHY_PATH:-/usr/share/omarchy}/themes/$THEME/backgrounds/$BACKGROUND" || true

step "Reloading desktop"
hyprctl reload >/dev/null && hyprctl configerrors
omarchy restart shell

step "Done"
echo "Log out and back in once so every app picks up the new config."
