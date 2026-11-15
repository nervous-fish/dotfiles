#!/usr/bin/env bash
# niri only re-scrolls the view on focus changes, not when a column resizes.
# After a resize (unfloat, un-maximize), bounce focus to a neighbour column and
# back so the view is recomputed for the new width. Optional args: a niri action
# to run first (e.g. `realign-view.sh maximize-column`).
set -euo pipefail

if [ $# -gt 0 ]; then
    niri msg action "$@"
fi

sleep 0.15
win="$(niri msg --json focused-window)"
[ "$(jq -r '.is_floating' <<<"$win")" = "false" ] || exit 0

col="$(jq -r '.layout.pos_in_scrolling_layout[0]' <<<"$win")"
if [ "$col" -gt 1 ]; then
    niri msg action focus-column-left
    niri msg action focus-column-right
else
    niri msg action focus-column-right
    niri msg action focus-column-left
fi
