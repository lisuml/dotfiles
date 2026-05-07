# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Setup

```sh
chezmoi init --apply https://github.com/michal-lisowski/dotfiles
```

## What's managed

| Path | Description |
|------|-------------|
| `~/.gitconfig` | Git config with GPG signing, Dracula theme colors |
| `~/.bashrc` / `~/.zshrc` / `~/.zshenv` | Shell environment |
| `~/.p10k.zsh` | Powerlevel10k prompt theme (Arch-branded) |
| `~/.vimrc` | Vim config |
| `~/.config/hypr/` | Hyprland compositor |
| `~/.config/waybar/` | Waybar status bar |
| `~/.config/nwg-launchers/nwgbar/` | nwgbar power menu |
| `~/.config/foot/` | Foot terminal |
| `~/.config/ranger/` | Ranger file manager |
| `~/.config/keepassxc/` | KeePassXC settings |
| `~/.config/gammastep/` | Gammastep (night light) |
| `~/.config/kanshi/` | Kanshi display profiles |
| `~/.config/wpaperd/` | wpaperd wallpaper daemon |
| `~/.config/autostart/` | Autostart entries |
| `~/.config/mimeapps.list` | Default application associations |
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

## chezmoi file naming

- `dot_` → installed as `.` (e.g. `dot_gitconfig` → `~/.gitconfig`)
- `executable_` → installed with execute bit
- `private_` → installed with mode 0600
- `*.tmpl` → processed as Go templates
