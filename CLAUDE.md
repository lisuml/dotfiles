# chezmoi dotfiles

This is a chezmoi-managed dotfiles repository for Michał Lisowski.

## Commit conventions

- Use the format `<scope>: <description>` (e.g. `gitconfig: enable GPG signing`)
- Split unrelated changes into separate commits — one commit per logical concern
- Include all relevant changes in the commit message (e.g. if a file was renamed AND new content was added, mention both)

## File naming

chezmoi uses prefixed filenames:
- `dot_` prefix → maps to `.` in the home directory (e.g. `dot_gitconfig` → `~/.gitconfig`)
- `executable_` prefix → file is installed as executable
- `private_` prefix → file is installed with restricted permissions (mode 0600)
