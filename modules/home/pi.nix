# pi — terminal-based coding agent (https://github.com/earendil-works/pi)
#
# Everything pi-related is provided the `pi-agent` flake.
#
# The module sets `programs.pi-agent.enable` (default false). Set it per-host
# (or globally) to turn on pi. Disable with `programs.pi-agent.enable = false`
# on hosts that shouldn't have it (see machines/honor/home.nix).
{
  pi-agent,
  lib,
  ...
}: {
  imports = [pi-agent.homeManagerModules.default];

  # Enable pi everywhere by default; a host can override with
  # programs.pi-agent.enable = false (see machines/honor/home.nix).
  programs.pi-agent.enable = lib.mkDefault true;
}
