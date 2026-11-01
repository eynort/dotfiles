# dotfiles

My personal Linux desktop config. The current setup runs on
[Omarchy](https://omarchy.org/) (Arch + Hyprland). The previous vanilla Arch setup is
still here, see [Legacy: vanilla Arch setup](#legacy-vanilla-arch-setup).

## Repo layout

| Path | What it is |
| :--- | :--- |
| `omarchy/` | [GNU Stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`: the Omarchy config for every machine |
| `omarchy-desktop/` | Stow package with desktop-only config (monitor resolution and scaling) |
| `omarchy-install.sh` | Turns a fresh Omarchy install into this setup |
| `omarchy-packages.txt` | Packages installed on top of stock Omarchy (`aur:` prefix for AUR) |
| `sync.sh` | Pulls config changes Omarchy made back into the repo |
| everything else | Legacy vanilla Arch setup |

Only user overrides are tracked. Omarchy's own defaults in `/usr/share/omarchy` are
never copied, so `omarchy update` keeps working as usual.

## What's in the Omarchy setup

- **Hyprland**: scrolling layout, no gaps, borders, rounding or animations, and
  inactive windows dimmed (`hypr/looknfeel.lua`).
- **Bar**: a clone of the Omarchy bar (`pc.bar`) with a CPU/GPU/RAM stats widget
  (`omarchy/bar/scripts/sysstats`) and a G435 headset mode button.
- **G435 Bluetooth headset**: stays in high-quality A2DP instead of switching to the
  16 kHz "phone" profile whenever an app opens the mic
  (`wireplumber/.../bluetooth-no-hfp-autoswitch.conf`). The bar button
  (`~/.local/bin/g435-mode`) switches between music and call mode.
- **Dictation**: Voxtype (Whisper, Spanish). `SUPER + H` switches the headset to call
  mode, records, and switches back when pressed again (`~/.local/bin/dictate-g435`).
- **Theme**: Vantablack with the *Layers Stacked* background.
- **User services**: Voxtype, a desktop notification when systemd-oomd kills
  something (`oomd-notify`), and a headless Chromium for Codex's DevTools MCP.
- **Terminals, Neovim (LazyVim), tmux, btop, starship, mise**.

### Custom keybindings

On top of Omarchy's defaults (`omarchy menu keybindings --print`):

| Keybinding | Action |
| :--- | :--- |
| `SUPER` + `H` | Toggle dictation through the G435 mic |
| `SUPER` + `SHIFT` + `CTRL` + `A` | Codex desktop (replaces Omarchy's agent binding) |
| `CTRL` + `SHIFT` + `C` | Claude desktop |

## Install on a fresh Omarchy machine

```bash
git clone https://github.com/eynort/dotfiles.git ~/Downloads/dotfiles
~/Downloads/dotfiles/omarchy-install.sh            # laptop / any machine
~/Downloads/dotfiles/omarchy-install.sh --desktop  # + desktop monitor config
```

The script can be run from wherever the repo was cloned. It:

1. Moves the repo to `~/dotfiles`, since every config symlink points there.
2. Installs the packages in `omarchy-packages.txt`, plus Steam and Voxtype through
   Omarchy's own installers (they pick the right drivers for the hardware).
3. Links the config with `stow --no-folding --adopt`. On the first run the repo version
   replaces the stock files Omarchy shipped.
4. Enables the user services and applies the theme.

It is safe to re-run: later runs keep local edits. Laptops keep Omarchy's
auto-detected `monitors.lua`.

**What it can't bring over:** logins (GitHub, browsers, AI CLIs), files in
`~/Documents` or `~/Videos` (e.g. the live wallpaper video), and BIOS/hardware settings.

## Day to day

Files in `$HOME` are symlinks into this repo, so editing them edits the repo.

Some Omarchy commands rewrite their file in place (moving bar widgets, changing text
size or monitor scaling), which turns the symlink back into a plain file. `sync.sh`
moves those files back into the repo and relinks them, so run it before every commit:

```bash
cd ~/dotfiles
./sync.sh        # adopt changes made by Omarchy, then review with git diff
git add -A && git commit -m "..." && git push
```

- **New config file**: move it into `omarchy/` at the same path, then run `./sync.sh`.
- **After `omarchy refresh <x>`**: `./sync.sh` brings the fresh default into the repo.
  `git diff` shows it, and `git checkout -- <file>` restores your version.

**Not tracked on purpose:** anything with credentials (`gh`, `git`, browsers, AI CLIs),
the theme files Omarchy repoints on every theme change (nvim `theme.lua`, btop
`current.theme`), `factory.dashboard` (it links to another project), and `.bak.*`
backups.

---

## Legacy: vanilla Arch setup

My setup before Omarchy: Hyprland on plain Arch.

> Don't run `install.sh` on Omarchy. It's only for this vanilla setup and would
> overwrite Omarchy's config.

### Installation

`install.sh` installs the needed packages with `pacman` and symlinks every config file
in the repo root into your home directory. Review it before running:

```bash
./install.sh
```

### Components

| Component | Tool | Config |
| :--- | :--- | :--- |
| Window manager | Hyprland | `hypr/hyprland.conf` |
| Terminal | Kitty | `kitty/kitty.conf` |
| Editor | Neovim (`lazy.nvim`) | `nvim/` |
| Status bar | Waybar | `waybar/` |
| File manager | Dolphin | `dolphinrc` |
| Launcher | wofi (`SUPER` + `Space`) | `hypr/hyprland.conf` |
| Logout menu | wlogout | `wlogout/` |
| Wallpaper | hyprpaper | `hypr/hyprpaper.conf`, `wallpapers/` |

### Keybindings

| Keybinding | Action |
| :--- | :--- |
| `SUPER` + `T` | Open terminal (Kitty) |
| `SUPER` + `Q` | Close active window |
| `SUPER` + `M` | Exit Hyprland |
| `SUPER` + `F` | Open file manager (Dolphin) |
| `SUPER` + `V` | Toggle floating window |
| `SUPER` + `Space` | Open application launcher (wofi) |
| `SUPER` + `P` | Toggle pseudotiling |
| `SUPER` + `J` | Toggle split |
| `SUPER` + `SHIFT` + `S` | Take a screenshot of a region |
| `SUPER` + `left`/`right`/`up`/`down` | Move focus |
| `SUPER` + `1-9` | Switch to workspace 1-9 |
| `SUPER` + `ALT` + `1-9` | Move active window to workspace 1-9 |

### Theming

Waybar and wlogout are styled with CSS (`waybar/theme.css`, `waybar/style.css`,
`wlogout/style.css`). Window borders, shadows and blur are set in `hypr/hyprland.conf`.

### Screenshots

![Desktop](screenshots/desktop.png)
![Representation](screenshots/representation.png)
![Representation 2](screenshots/representation2.png)
