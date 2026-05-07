#!/bin/bash
# Screenshot current display (Shift+Print)

output_id=$(hyprctl -j monitors | jq -r '.[] | select(.focused).name')
grim -o $output_id - | swappy -f -
