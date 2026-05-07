#!/bin/bash
# Screenshot active window (Ctrl+Print)

grim -g "$(hyprctl -j activewindow | jq -r '.at + .size | "\(.[0]),\(.[1]) \(.[2])x\(.[3])"' | slurp)" - | swappy -f -
