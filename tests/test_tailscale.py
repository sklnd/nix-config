import json
import os
from pathlib import Path
import subprocess


PLUGIN = Path(__file__).resolve().parents[1] / "config/sketchybar/plugins/tailscale.sh"
MOCKS = r"""
tailscale() { printf '%s\n' "$TEST_STATUS"; return "$TEST_EXIT_CODE"; }
sketchybar() { printf '%s\0' "$@"; }
source "$1"
"""


def update(status: object, exit_code: int = 0) -> list[str]:
    result = subprocess.run(
        ["/bin/bash", "-c", MOCKS, "test", str(PLUGIN)],
        env={
            **os.environ, "NAME": "tailscale", "TEST_STATUS": json.dumps(status),
            "TEST_EXIT_CODE": str(exit_code),
        },
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.rstrip("\0").split("\0")


def test_connected_without_exit_node():
    args = update({"BackendState": "Running", "Peer": {"peer": {"ExitNodeOption": True}}})
    assert "label=Tailscale" in args
    assert "icon.color=0xffa6da95" in args


def test_disconnected_or_logged_out():
    for state in ("Stopped", "NeedsLogin"):
        assert "label=Tailscale off" in update({"BackendState": state})


def test_selected_exit_node_and_offline_warning():
    for online in (True, False):
        args = update({
            "BackendState": "Running",
            "ExitNodeStatus": {"ID": "node1", "Online": online},
            "Peer": {"key": {"ID": "node1", "HostName": "Home gateway"}},
        })
        assert f"label={'Exit' if online else 'Exit offline'}: Home gateway" in args
        assert f"icon.color={'0xffc29df1' if online else '0xffed8796'}" in args


def test_exit_node_without_peer_details():
    args = update({"BackendState": "Running", "ExitNodeStatus": {"ID": "node1", "Online": True}})
    assert "label=Exit: node1" in args


def test_unavailable_or_invalid_status():
    for status in (None, "invalid status", {}):
        assert "label=Tailscale unavailable" in update(status)
    assert "label=Tailscale unavailable" in update({"BackendState": "Running"}, exit_code=1)
