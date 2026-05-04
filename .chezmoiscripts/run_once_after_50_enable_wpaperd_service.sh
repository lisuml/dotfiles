#!/bin/sh
set -e

systemctl --user daemon-reload
systemctl --user enable wpaperd.service

# Only start immediately if already in a graphical session
if [ -n "$WAYLAND_DISPLAY" ]; then
    systemctl --user start wpaperd.service
fi
