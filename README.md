# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Setup

```sh
chezmoi init --apply https://github.com/lisuml/dotfiles
```

## What's managed

| Path | Description |
|------|-------------|
| `~/.gitconfig` | Git config with GPG signing, Dracula theme colors |
| `~/.bashrc` / `~/.zshrc` / `~/.zshenv` | Shell environment |
| `~/.p10k.zsh` | Powerlevel10k prompt theme (Arch-branded) |
| `~/.vimrc` | Vim config |
| `~/.config/hypr/` | Hyprland compositor (Lua config), hyprlock, hypridle |
| `~/.config/waybar/` | Waybar status bar |
| `~/.config/nwg-launchers/nwgbar/` | nwgbar power menu |
| `~/.config/foot/` | Foot terminal |
| `~/.config/ranger/` | Ranger file manager |
| `~/.config/keepassxc/` | KeePassXC settings |
| `~/.config/rofi-rbw.rc` | rofi-rbw — Bitwarden picker over `rbw`, launched by `bw-picker` / `bw-open` |
| `~/.config/gammastep/` | Gammastep (night light) |
| `~/.config/kanshi/` | Kanshi display profiles |
| `~/.config/wpaperd/` | wpaperd wallpaper daemon |
| `~/.config/autostart/` | Autostart entries |
| `~/.config/mimeapps.list` | Default application associations — set via `xdg-mime` in `.chezmoiscripts/run_onchange_60_default_applications.sh`, not managed as a file (Thunderbird and Firefox mutate it at runtime) |
| `~/.config/systemd/` | User systemd units |
| `~/.mozilla/` | Firefox profile |
| `~/.local/bin/` | Personal scripts |
| `~/.ssh/` | SSH config |

## Other files in this repo

| File | Description |
|------|-------------|
| `bootstrap.sh` | Arch Linux bootstrap script — sets up network, SSH key, yay, and clones the Ansible repo. Fetched on a fresh install before any authentication is available. |
| `CLAUDE.md` | Instructions for Claude Code |
| `README.md` | This file |

These are excluded from chezmoi installation via `.chezmoiignore`.

## Machine-specific data (Ansible)

Some dotfiles are Go templates (`.tmpl`) that require machine-specific data injected via `~/.config/chezmoi/chezmoi.toml`. This file is **not** in the repo — it is rendered by the [Ansible repo](https://github.com/lisuml/infra-ansible) (`roles/chezmoi`) on each managed host.

| Template variable | Source | Used in |
|---|---|---|
| `.git.name`, `.git.signingkey` | `group_vars` | `~/.gitconfig` |
| `.git.credential_helpers` | `group_vars` | `~/.gitconfig` |
| `.ssh.hosts` | `group_vars` | `~/.ssh/config` |
| `.mattermost.servers` | `group_vars` | Mattermost config |
| `.birdtray.*` | `group_vars` | Birdtray config |

On a machine not managed by Ansible, create `~/.config/chezmoi/chezmoi.toml` manually before running `chezmoi apply`.

## chezmoi file naming

- `dot_` → installed as `.` (e.g. `dot_gitconfig` → `~/.gitconfig`)
- `executable_` → installed with execute bit
- `private_` → installed with mode 0600
- `*.tmpl` → processed as Go templates
