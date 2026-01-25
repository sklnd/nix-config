{pkgs, ...}: let
  aerospaceConfig = builtins.readFile ../../config/aerospace/aerospace.toml;
in {
  system = {
    defaults.NSGlobalDomain._HIHideMenuBar = true;
    defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
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
