import os
from pathlib import Path
import subprocess


PLUGIN = Path(__file__).resolve().parents[1] / "config/sketchybar/plugins/wifi.sh"
MOCKS = r"""
networksetup() {
    printf 'Hardware Port: Wi-Fi\nDevice: en0\n\nHardware Port: USB 10/100/1000 LAN\nDevice: en5\n'
}
route() {
    case "$*" in
        '-n get default') interface=$TEST_INTERFACE ;;
        '-n get -inet6 default') interface=$TEST_IPV6_INTERFACE ;;
        *) return 1 ;;
    esac
    [ -n "$interface" ] || return 1
    printf '  interface: %s\n' "$interface"
}
ipconfig() { printf ' SSID : %s\n' "$TEST_SSID"; }
sketchybar() { printf '%s\0' "$@"; }
source "$1"
"""


def update(interface: str, ssid: str = "Home network", ipv6: str = "", sender: str = "routine") -> list[str]:
    result = subprocess.run(
        ["/bin/bash", "-c", MOCKS, "test", str(PLUGIN)],
        env={
            **os.environ, "NAME": "wifi", "SENDER": sender,
            "TEST_INTERFACE": interface, "TEST_IPV6_INTERFACE": ipv6, "TEST_SSID": ssid,
        },
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.rstrip("\0").split("\0")


def test_wifi_name_on_reload_network_change_and_poll():
    for sender in ("forced", "wifi_change", "routine"):
        assert update("en0", sender=sender) == [
            "--set", "wifi", "label=Home network", "icon=",
        ]
    assert "label=Wi-Fi" in update("en0", ssid="")


def test_wired_default_route_takes_precedence_over_connected_wifi():
    assert update("en5") == ["--set", "wifi", "label=Wired", "icon=󰈀"]


def test_ipv6_only_connection():
    assert "label=Wired" in update("", ipv6="en5")
    assert "label=Home network" in update("", ipv6="en0")


def test_no_route_shows_disconnected_even_if_wifi_name_is_available():
    assert "label=Not Connected" in update("")


def test_unknown_or_vpn_interface_is_not_called_wired():
    assert "label=utun3" in update("utun3")
