This repository contains my personal dotfiles for a customized Linux desktop environment. The setup is based on the Hyprland Wayland compositor and is designed to be both aesthetically pleasing and highly functional.

## Installation

The `install.sh` script is provided to automate the setup process. It will install the necessary packages using `pacman` and create symbolic links for all the configuration files in this repository to their appropriate locations in your home directory.

Before running the script, you should review its contents to ensure that it meets your needs and that you have the necessary permissions to install the packages.

To run the installation script, execute the following command in your terminal:

```bash
./install.sh
```

## Configuration

This setup uses a combination of applications to create a complete desktop environment. The following is a breakdown of the main components and their configurations:

### Window Manager

*   **Hyprland**: A dynamic tiling Wayland compositor that provides a modern and fluid user experience. The main configuration file is located at `hypr/hyprland.conf`.

### Terminal

*   **Kitty**: A fast, feature-rich, and GPU-based terminal emulator. The configuration file is located at `kitty/kitty.conf`.

### Text Editor

*   **Neovim**: A highly extensible and customizable text editor. The configuration is written in Lua and is located in the `nvim/` directory. It uses `lazy.nvim` for plugin management.

### Status Bar

*   **Waybar**: A highly customizable Wayland bar for Sway and Wlroots based compositors such as Hyprland. The configuration is located in the `waybar/` directory.

### File Manager

*   **Dolphin**: The default file manager for KDE Plasma, configured to be lightweight and minimalistic. The configuration file is located at `dolphinrc`.

### Application Launcher

*   **wofi**: A fast and lightweight application launcher for Wayland. It is configured in `hypr/hyprland.conf` to be launched with the `SUPER` + `Space` key combination.

### Logout Menu

*   **wlogout**: A simple and elegant logout menu for Wayland. The configuration is located in the `wlogout/` directory.

## Keybindings

The following are some of the most important keybindings defined in `hypr/hyprland.conf`:

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

## Theming

The theming of this desktop environment is designed to be consistent and visually appealing. The following are the main components of the theme:

*   **Wallpapers**: A collection of wallpapers is included in the `wallpapers/` directory. The wallpaper is set using `hyprpaper`, and the configuration is located at `hypr/hyprpaper.conf`.
*   **Waybar**: The Waybar status bar is styled using CSS. The theme is defined in `waybar/theme.css` and the overall style is in `waybar/style.css`.
*   **wlogout**: The logout menu is also styled using CSS. The style is defined in `wlogout/style.css`.
*   **Hyprland**: The Hyprland configuration in `hypr/hyprland.conf` includes settings for window decorations, such as borders, shadows, and blur effects.

## Screenshots

![Desktop](screenshots/desktop.png)
![Representation](screenshots/representation.png)
![Representation 2](screenshots/representation2.png)



## Omarchy

My current setup runs on [Omarchy](https://omarchy.org/). Its config lives in the
`omarchy/` and `omarchy-desktop/` [GNU Stow](https://www.gnu.org/software/stow/) package, which mirrors
`$HOME`. Only user overrides are tracked (`~/.config/hypr`, `~/.config/omarchy`,
terminals, nvim, wireplumber, voxtype, user systemd units, `~/.local/bin` scripts);
Omarchy's own defaults in `/usr/share/omarchy` are never copied.

> The `install.sh` and top-level folders above are for the old vanilla Arch setup.
> Don't run `install.sh` on Omarchy.

### Install on a fresh Omarchy machine

```bash
git clone https://github.com/eynort/dotfiles.git ~/Downloads/dotfiles
~/Downloads/dotfiles/omarchy-install.sh            # laptop / any machine
~/Downloads/dotfiles/omarchy-install.sh --desktop  # + desktop monitor config
```

Wherever it was cloned, the script first moves the repo to `~/dotfiles` (the symlinks point there), installs the
packages in `omarchy-packages.txt` plus Steam and Voxtype through Omarchy's own
installers, links the config with `stow --no-folding`, enables the user services and
applies the theme. It is safe to re-run.

`omarchy-desktop/` holds config that only fits the desktop (monitor resolution and
scaling); laptops keep Omarchy's auto-detected `monitors.lua`.

What it can't bring over: logins (GitHub, browsers, AI CLIs), files in `~/Documents`
or `~/Videos` (e.g. the live wallpaper video), and BIOS/hardware settings.

### Day to day

Files in `$HOME` are symlinks into this repo, so editing them edits the repo. Some
Omarchy commands (moving bar widgets, changing text size or monitor scaling) rewrite
their file in place, which turns the symlink back into a plain file. `sync.sh` pulls
those files back into the repo and relinks them, so run it before every commit:

```bash
cd ~/dotfiles
./sync.sh        # adopt changes made by Omarchy, then review with git diff
git add -A && git commit -m "..." && git push
```

- **New config file**: move it into `omarchy/` at the same path, then run `./sync.sh`.
- **After `omarchy refresh <x>`**: `./sync.sh` brings the fresh default into the repo;
  `git diff` shows it, and `git checkout -- <file>` restores your version.

Not tracked on purpose: `factory.dashboard` (it links to another project), anything with
credentials (`gh`, `git`, browsers, AI CLIs), and the `.bak.*` backups.
