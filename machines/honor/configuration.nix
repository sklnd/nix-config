{...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ../../modules/desktop/darwin.nix

    ../../modules/system/nix-darwin.nix
    ../../modules/system/security-darwin.nix
    ../../modules/system/fonts.nix
  ];
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  ids.gids.nixbld = 350;

  system = {
    primaryUser = "chris.skalenda";
    stateVersion = 4;
  };
}
