{pkgs, ...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ../../modules/desktop/darwin.nix

    ../../modules/system/nix-darwin.nix
    ../../modules/system/security-darwin.nix
  ];

  networking.hostName = machineDefs.hostname;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;

  system = {
    primaryUser = "chris";
    stateVersion = 4;
  };
}
