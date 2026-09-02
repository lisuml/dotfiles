# chezmoi dotfiles

This is a chezmoi-managed dotfiles repository for Michał Lisowski. System-level
config (packages, services, files outside `$HOME`) is managed by Ansible in a
separate private repo, not here.

**This repo is public.** Never name internal or work-owned hosts, repos, image
registries, or scripts — in files, comments, or commit messages. Describe them
generically ("the work dev-container launcher").

## Workflow

- Edit the source here, then `chezmoi apply` — never write directly to `~` (that includes `~/.claude/`).
- Run `chezmoi diff` before committing: live app configs drift from the source, and committing without checking leaves chezmoi trying to undo those live changes on the next apply.
- To clear an unwanted diff, keep the live file — `chezmoi re-add <file>`. `chezmoi apply` would overwrite it.

## File naming

chezmoi uses prefixed filenames:
- `dot_` prefix → maps to `.` in the home directory (e.g. `dot_gitconfig` → `~/.gitconfig`)
- `executable_` prefix → file is installed as executable
- `private_` prefix → file is installed with restricted permissions (mode 0600)
- `.tmpl` suffix → rendered as a Go template
- `.chezmoiignore` → kept in the repo, not installed; `.chezmoiremove` → paths to delete from the target

## Scripts

`.chezmoiscripts/run_once_*` and `run_onchange_*`, numeric prefix for ordering;
`run_once_after_*` runs after the rest of the state is applied. `run_once_` scripts
re-run when their contents change, so treat them as idempotent.

## Templates

Template data comes from `~/.config/chezmoi/chezmoi.toml`, which is **not** in this
repo — Ansible renders it per host. A new template variable therefore also needs a
`dotfile_*` var and a `chezmoi.toml` line on the Ansible side. Machine- and
work-specific values live there, which is what keeps them out of this public repo.

## Commit conventions

- Use the format `<scope>: <description>` (e.g. `gitconfig: enable GPG signing`)
- Split unrelated changes into separate commits — one commit per logical concern
- Include all relevant changes in the commit message (e.g. if a file was renamed AND new content was added, mention both)

## README

Always update `README.md` when new configs or tools are added to the repo (new entries in the "What's managed" table).
