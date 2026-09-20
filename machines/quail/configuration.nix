{...}: let
  machineDefs = import ./system.nix {};
  primaryUser = "chris";
in {
  imports = [
    ../../modules/desktop/darwin.nix

    ../../modules/system/nix-darwin.nix
    ../../modules/system/security-darwin.nix
  ];

  networking.hostName = machineDefs.hostname;
  nixpkgs.hostPlatform = machineDefs.hostPlatform;

  system = {
    inherit primaryUser;
    stateVersion = 4;
  };
}
