#!/usr/bin/env fish

# Log into GitHub via HTTPS first, then upload key and switch to SSH
if type -q gh
    if not gh auth status >/dev/null 2>&1
        echo "🔐 Logging in to GitHub (HTTPS)…"
        gh auth login --hostname github.com --web --git-protocol https
    end

    echo "⬆️  Uploading SSH key to GitHub…"
    if gh ssh-key add "$HOME/.ssh/id_ed25519.pub" -t "{{ .chezmoi.hostname }}"
        gh config set git_protocol ssh >/dev/null 2>&1; or true
        gh auth setup-git        >/dev/null 2>&1; or true
        echo "✅ Key uploaded and Git set to use SSH."
    else
        echo "⚠️  Failed to upload SSH key to GitHub."
    end
else
    echo "ℹ️  GitHub CLI (gh) not installed — skipping."
end
