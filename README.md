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
| `~/.bashrc` / `~/.zshenv` | Shell environment |
| `~/.vimrc` | Vim config |
| `~/.config/hypr/` | Hyprland compositor |
| `~/.config/waybar/` | Waybar status bar |
| `~/.config/foot/` | Foot terminal |
| `~/.config/ranger/` | Ranger file manager |
| `~/.config/keepassxc/` | KeePassXC settings |
| `~/.config/gammastep/` | Gammastep (night light) |
| `~/.config/kanshi/` | Kanshi display profiles |
| `~/.config/autostart/` | Autostart entries |
| `~/.config/mimeapps.list` | Default application associations |
| `~/.config/systemd/` | User systemd units |
| `~/.mozilla/` | Firefox profile |
| `~/.local/bin/` | Personal scripts |
| `~/.ssh/` | SSH config |

## chezmoi file naming

- `dot_` → installed as `.` (e.g. `dot_gitconfig` → `~/.gitconfig`)
- `executable_` → installed with execute bit
- `private_` → installed with mode 0600
- `*.tmpl` → processed as Go templates
