#!/bin/sh
set -e

# Enable and start the user ssh-agent socket if systemd is available
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user enable --now ssh-agent.socket || true
fi
