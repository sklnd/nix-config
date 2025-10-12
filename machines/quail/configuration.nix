{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  imports = [
    ../../modules/aerospace.nix
    ../../modules/jankyborders.nix
  ];

  system.primaryUser = "chris";
  environment.systemPackages = with pkgs; [
    home-manager
    snd-ctl
    thrift
    #sketchybar
  ];
  networking.hostName = machineDefs.hostname;
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  services = {
    sketchybar.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
