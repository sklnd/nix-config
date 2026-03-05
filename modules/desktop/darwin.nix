{pkgs, ...}: let
  aerospaceConfig = builtins.readFile ../../config/aerospace/aerospace.toml;
in {
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    defaults.NSGlobalDomain._HIHideMenuBar = true;
    defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
    defaults.NSGlobalDomain.KeyRepeat = 2;
    defaults.NSGlobalDomain.InitialKeyRepeat = 15;
    defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
    defaults.dock.autohide = true;
  };
  environment.systemPackages = with pkgs; [
    jankyborders
    snd-ctl
  ];

  services = {
    sketchybar.enable = true;

    aerospace = {
      enable = true;
      settings = builtins.fromTOML aerospaceConfig;
    };
  };
}
