#!/bin/bash
# One item per workspace, drawn on the bar of the monitor that workspace lives on.
# AeroSpace has no persistent workspaces, so its list is the only truth about what
# exists: everything with windows, plus each monitor's visible one, plus the focused one.

focused=${FOCUSED:-$(aerospace list-workspaces --focused 2>/dev/null)}
list=$(aerospace list-workspaces --all \
    --format '%{workspace}|%{monitor-id}|%{workspace-is-visible}' 2>/dev/null) || exit 0

# AeroSpace not up yet: leave the bar as it is instead of hiding everything
[ -z "$focused" ] && exit 0

# Match AeroSpace's x/y ordering to SketchyBar's independent arrangement IDs.
display_order=$(sketchybar --query displays | jq -er \
    'sort_by(.frame.x, .frame.y) | map(."arrangement-id") | @tsv') || exit 0
read -r -a displays <<<"$display_order"

args=()
prev=space.template
while IFS='|' read -r sid monitor visible; do
    [ -z "$sid" ] && continue
    display=${displays[$((monitor - 1))]}
    # Displays may be in flux while docking: leave the bar alone until they agree.
    [ -z "$display" ] && exit 0
    args+=(--clone "space.$sid" "$prev" after
        --set "space.$sid" label="$sid" click_script="aerospace workspace $sid"
        display="$display" drawing=on
        background.color=0x00000000 label.color=0xffa5adcb background.border_width=0)
    if [ "$visible" = true ] && [ "$sid" != "$focused" ]; then
        args+=(background.color=0x00000000
            background.border_width=2 background.border_color=0xffc29df1)
    fi
    prev="space.$sid"
done <<<"$list"
args+=(--set "space.$focused" background.color=0xffc29df1 label.color=0xff24273a)

# Hidden first, so items for workspaces that no longer exist disappear
sketchybar --set '/^space\./' drawing=off "${args[@]}" >/dev/null
