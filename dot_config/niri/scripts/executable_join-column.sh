#!/usr/bin/env bash
# Move the focused window into the neighbouring column in one press.
# niri's consume-or-expel-window-<dir> first expels a stacked window into its
# own column and only joins the neighbour on a second press. If the window is
# stacked AND a neighbour column exists on that side, do both steps at once;
# otherwise behave like the native action (join, or expel at the edge).
# Usage: join-column.sh left|right
set -euo pipefail

dir="$1"
action="consume-or-expel-window-$dir"

win="$(niri msg --json focused-window)"
if [ "$win" = "null" ] || [ "$(jq -r '.is_floating' <<<"$win")" = "true" ]; then
    niri msg action "$action"
    exit 0
fi

ws="$(jq -r '.workspace_id' <<<"$win")"
col="$(jq -r '.layout.pos_in_scrolling_layout[0]' <<<"$win")"

read -r in_col max_col < <(niri msg --json windows | jq -r --argjson ws "$ws" --argjson col "$col" '
    [.[] | select(.workspace_id == $ws and .is_floating == false) | .layout.pos_in_scrolling_layout[0]]
    | "\(map(select(. == $col)) | length) \(max)"')

has_neighbour=false
if [ "$dir" = left ] && [ "$col" -gt 1 ]; then has_neighbour=true; fi
if [ "$dir" = right ] && [ "$col" -lt "$max_col" ]; then has_neighbour=true; fi

niri msg action "$action"
if [ "$in_col" -gt 1 ] && [ "$has_neighbour" = true ]; then
    niri msg action "$action"
fi
