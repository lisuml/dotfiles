#!/bin/sh
set -e

# Packaged unit: Restart=on-failure covers geoclue not answering at login
systemctl --user enable gammastep.service

# Only start immediately if already in a graphical session
if [ -n "$WAYLAND_DISPLAY" ]; then
    systemctl --user start gammastep.service
fi
