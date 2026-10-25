{pkgs, ...}: let
  aerospaceConfig = builtins.readFile ../../config/aerospace/aerospace.toml;
in {
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    defaults = {
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        "com.apple.swipescrolldirection" = false;
      };
      dock.autohide = true;
    };
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
