{pkgs, ...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ../../modules/aerospace.nix
  ];
  system = {
    primaryUser = "chris.skalenda";
    defaults.NSGlobalDomain._HIHideMenuBar = true;
    defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
  environment.systemPackages = with pkgs; [
    snd-ctl
    jankyborders
  ];
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    sketchybar.enable = true;
  };

  ids.gids.nixbld = 350;
}
