{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  system.primaryUser = "chris.skalenda";
  environment.systemPackages = with pkgs; [
    snd-ctl
  ];
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  services.sketchybar.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  ids.gids.nixbld = 350;
}
