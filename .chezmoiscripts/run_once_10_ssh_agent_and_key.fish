#!/usr/bin/env fish

# Shared ssh-agent for all terminals
set -l sock "$XDG_RUNTIME_DIR/ssh-agent.socket"
if not test -S "$sock"
    eval (ssh-agent -c -a "$sock")
end
set -Ux SSH_AUTH_SOCK "$sock"
if set -q SSH_AGENT_PID
    set -Ux SSH_AGENT_PID "$SSH_AGENT_PID"
end

# Secure ~/.ssh
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Generate key if missing
if not test -f "$HOME/.ssh/id_ed25519"
    echo "🔑 Generating per-device SSH key..."
    ssh-keygen -t ed25519 -a 100 -f "$HOME/.ssh/id_ed25519" -C "michal@{{ .chezmoi.hostname }}"
    chmod 600 "$HOME/.ssh/id_ed25519"
    chmod 644 "$HOME/.ssh/id_ed25519.pub"
end

# Add key to agent
ssh-add "$HOME/.ssh/id_ed25519"; or true
