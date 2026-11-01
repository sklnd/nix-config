import json
import os
from pathlib import Path
import subprocess


PLUGIN = Path(__file__).resolve().parents[1] / "config/sketchybar/plugins/aerospace.sh"
DISPLAYS = [
    {"arrangement-id": 1, "frame": {"x": 0, "y": 0}},
    {"arrangement-id": 2, "frame": {"x": 2560, "y": 0}},
    {"arrangement-id": 3, "frame": {"x": -2560, "y": 0}},
]
MOCKS = r"""
aerospace() {
    case "$*" in
        'list-workspaces --all --format %{workspace}|%{monitor-id}|%{workspace-is-visible}')
            printf '%s\n' "$TEST_WORKSPACES"
            return "$TEST_WORKSPACES_STATUS" ;;
        *) return 1 ;;
    esac
}
sketchybar() {
    case "$*" in
        '--query displays') printf '%s\n' "$TEST_DISPLAYS" ;;
        *) printf '%s\0' "$@" >&3 ;;
    esac
}
export -f aerospace sketchybar
exec /bin/bash "$1" 3>&1
"""


def refresh(
    workspaces: str, displays: object = DISPLAYS, workspace_status: int = 0,
) -> dict[str, dict[str, str]]:
    result = subprocess.run(
        ["/bin/bash", "-c", MOCKS, "test", str(PLUGIN)],
        env={
            **os.environ,
            "FOCUSED": "b",
            "TEST_WORKSPACES": workspaces,
            "TEST_DISPLAYS": json.dumps(displays),
            "TEST_WORKSPACES_STATUS": str(workspace_status),
        },
        capture_output=True,
        text=True,
        check=True,
    )
    args = result.stdout.split("\0")
    updates: dict[str, dict[str, str]] = {}
    name = None
    for index, arg in enumerate(args):
        if arg == "--set":
            name = args[index + 1]
        elif arg.startswith("--"):
            name = None
        elif name and "=" in arg:
            key, value = arg.split("=", 1)
            updates.setdefault(name, {})[key] = value
    return updates


def test_monitor_mapping_and_undocking():
    updates = refresh("c|1|true\nb|2|true\nt|3|true")
    assert updates["space.c"]["display"] == "3"
    assert updates["space.b"]["display"] == "1"
    assert updates["space.t"]["display"] == "2"

    updates = refresh("b|1|true", displays=[DISPLAYS[0]])
    assert updates["space.b"]["display"] == "1"
    assert updates[r"/^space\./"]["drawing"] == "off"


def test_focused_visible_and_hidden_styles():
    updates = refresh("c|1|true\nb|2|true\nm|3|false")
    assert updates["space.b"]["background.color"] == "0xffc29df1"
    assert updates["space.b"]["background.border_width"] == "0"
    assert updates["space.c"]["background.color"] == "0xff24273a"
    assert updates["space.c"]["background.border_width"] == "2"
    assert updates["space.c"]["background.border_color"] == "0xffc29df1"
    assert updates["space.m"]["background.border_width"] == "0"
    assert updates["space.m"]["background.color"] != "0xffc29df1"


def test_failed_workspace_query_leaves_bar_untouched():
    assert refresh("", workspace_status=1) == {}
