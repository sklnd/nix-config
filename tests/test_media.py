import json
import os
from pathlib import Path
import subprocess


PLUGIN = Path(__file__).resolve().parents[1] / "config/sketchybar/plugins/media.sh"
MOCKS = r"""
snd-ctl() { printf '%s\n' "$TEST_MEDIA_INFO"; }
sketchybar() { printf '%s\0' "$@" >&3; }
export -f snd-ctl sketchybar
exec /bin/bash "$1" 3>&1
"""


def update(info: object) -> list[str]:
    result = subprocess.run(
        ["/bin/bash", "-c", MOCKS, "test", str(PLUGIN)],
        env={**os.environ, "NAME": "media", "TEST_MEDIA_INFO": json.dumps(info)},
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.rstrip("\0").split("\0")


def test_playing_shows_title_and_artist():
    args = update({"is_playing": True, "title": "A song", "artist": "An artist"})
    assert args[:2] == ["--set", "media"]
    assert "label=A song · An artist" in args
    assert "drawing=on" in args


def test_paused_or_unavailable_media_hides_island():
    for info in ({"is_playing": False, "title": "A song"}, None):
        assert update(info) == ["--set", "media", "drawing=off"]


def test_missing_artist_does_not_add_separator():
    assert "label=A song" in update({"is_playing": True, "title": "A song"})
