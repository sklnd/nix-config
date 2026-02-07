{...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/boot-nixos.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking-nixos.nix
    ../../modules/system/nix.nix
    ../../modules/system/users.nix

    ../../modules/services/home-assistant.nix
    ../../modules/services/plex.nix
    ../../modules/services/ssh.nix
    ../../modules/services/vscode-server.nix
    ../../modules/services/xserver.nix

    ../../modules/hardware/bluetooth.nix
  ];

  networking.hostName = machineDefs.hostname;

  system.stateVersion = "24.11";
}
