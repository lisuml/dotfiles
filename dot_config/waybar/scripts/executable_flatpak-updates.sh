#!/bin/bash

# flatpak-updates.sh — pending Flatpak updates as waybar JSON; prints nothing when up to date

mapfile -t updates < <(flatpak remote-ls --updates --columns=application,branch 2>/dev/null)
(( ${#updates[@]} )) || exit 0

tooltip=$(printf '%s\\n' "${updates[@]//$'\t'/ }")
printf '{"text": "%d", "alt": "has-updates", "class": "has-updates", "tooltip": "%s"}\n' \
  "${#updates[@]}" "${tooltip%\\n}"
