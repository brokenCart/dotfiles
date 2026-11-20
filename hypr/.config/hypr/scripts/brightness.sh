#!/usr/bin/env bash
# Change screen brightness with brightnessctl, then show it in the SwayOSD pop-up.
# Usage: brightness.sh up|down
step=5%
case "$1" in
    up)   brightnessctl -q -e4 -n2 set "$step+" ;;
    down) brightnessctl -q -e4 -n2 set "$step-" ;;
    *)    echo "usage: $0 up|down" >&2; exit 1 ;;
esac
pct=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
swayosd-client --custom-icon display-brightness-symbolic \
    --custom-progress "$(awk -v p="$pct" 'BEGIN { printf "%.2f", p / 100 }')" \
    --custom-progress-text "${pct}%"
