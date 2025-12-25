{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  imports = [
    ../../modules/aerospace.nix
  ];

  system = {
    primaryUser = "chris";
    defaults.NSGlobalDomain._HIHideMenuBar = true;
    defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  };
  environment.systemPackages = with pkgs; [
    snd-ctl
    thrift
    jankyborders
    claude-code
    ncdu
  ];
  networking.hostName = machineDefs.hostname;
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    sketchybar.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
