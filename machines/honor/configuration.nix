{...}: let
  machineDefs = import ./system.nix {};
  primaryUser = "chris.skalenda";
in {
  imports = [
    ../../modules/desktop/darwin.nix

    ../../modules/system/nix-darwin.nix
    ../../modules/system/security-darwin.nix
    ../../modules/system/fonts.nix

    ../../modules/services/dnsmasq.nix
  ];
  nixpkgs.hostPlatform = machineDefs.hostPlatform;
  ids.gids.nixbld = 350;

  system = {
    inherit primaryUser;
    stateVersion = 4;
  };
}
