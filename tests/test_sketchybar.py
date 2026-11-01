from pathlib import Path
import subprocess


CONFIG = Path(__file__).resolve().parents[1] / "config/sketchybar/sketchybarrc"


def test_default_backgrounds_are_disabled_after_setting_color():
    result = subprocess.run(
        [
            "zsh", "-c",
            'sketchybar() { if [[ $1 == --default ]]; then printf "%s\\n" "$@"; fi; }; source "$1"',
            "test", str(CONFIG),
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    drawing = False
    for arg in result.stdout.splitlines():
        if arg.startswith("background.color="):
            drawing = True  # SketchyBar enables drawing when setting a background color.
        elif arg.startswith("background.drawing="):
            drawing = arg == "background.drawing=on"
    assert "background.color=" in result.stdout
    assert not drawing


def test_workspace_island_has_permanent_edges():
    result = subprocess.run(
        [
            "zsh", "-c",
            'sketchybar() { printf "%s\\n" "$@"; }; source "$1"',
            "test", str(CONFIG),
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    args = result.stdout.splitlines()
    assert args.index("workspaces.start") < args.index("space.template") < args.index("workspaces.end")
    assert args.index("workspaces.end") < args.index("app.gap") < args.index("front_app")
    assert args.index("front_app") < args.index("front_app.name")
    bracket = args.index("workspaces")
    assert args[bracket - 2:bracket + 3] == [
        "--add", "bracket", "workspaces", "workspaces.start", "workspaces.end",
    ]
    # Right-side items are placed right to left.
    assert args.index("wifi") < args.index("tailscale")
    status = args.index("system_status")
    assert args[status - 2:status + 5] == [
        "--add", "bracket", "system_status", "tailscale", "wifi", "volume", "battery",
    ]
