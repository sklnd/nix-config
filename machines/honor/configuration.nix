{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
