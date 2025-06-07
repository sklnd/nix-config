{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  system.primaryUser = "chris";
  environment.systemPackages = [
    pkgs.home-manager
    pkgs.thrift
  ];
  networking.hostName = machineDefs.hostname;
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
