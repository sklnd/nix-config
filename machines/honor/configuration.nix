{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

   ids.gids.nixbld = 350;
}
