#!/usr/bin/env bash
# Toggle floating on the focused window. When a window goes floating -> tiled,
# niri keeps its floating pixel width, which is slightly off from the tiled
# proportion (floating proportions ignore gaps). Snap it to the nearest preset
# so columns line up and nothing overflows the screen.
set -euo pipefail

niri msg action toggle-window-floating

win="$(niri msg --json focused-window)"
[ "$(jq -r '.is_floating' <<<"$win")" = "false" ] || exit 0

width="$(jq -r '.layout.tile_size[0]' <<<"$win")"
out_width="$(niri msg --json focused-output | jq -r '.logical.width')"

# Nearest of the preset-column-widths in cfg/layout.kdl.
pct="$(awk -v w="$width" -v o="$out_width" 'BEGIN {
    r = w / o; best = 25; bd = 2
    n = split("25 50", p, " ")
    for (i = 1; i <= n; i++) { d = r - p[i] / 100; if (d < 0) d = -d; if (d < bd) { bd = d; best = p[i] } }
    print best
}')"

niri msg action set-column-width "${pct}%"

"$(dirname -- "$(readlink -f -- "$0")")/realign-view.sh"
