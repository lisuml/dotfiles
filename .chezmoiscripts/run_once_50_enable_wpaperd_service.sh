#!/bin/sh
set -e

echo "Enabling wpaperd systemd user service..."

systemctl --user daemon-reload

systemctl --user enable --now wpaperd.service

