{ pkgs, ... }:
let
  machineDefs = import ./system.nix { };
in
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/locale.nix
    ../../modules/system/networking-nixos.nix
    ../../modules/system/nix.nix
    ../../modules/system/users.nix

    ../../modules/services/home-assistant.nix
    ../../modules/services/plex.nix
    ../../modules/services/ssh.nix

    (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "09j4kvsxw1d5dvnhbsgih0icbrxqv90nzf0b589rb5z6gnzwjnqf";
    })
  ];

  programs.zsh.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = machineDefs.hostname;

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    vscode-server.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    gnumake
  ];

  system.stateVersion = "24.11";
}
