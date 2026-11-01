{pkgs, ...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/locale.nix
    ../../modules/services/ssh.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.zsh.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = machineDefs.hostname;
  networking.networkmanager.enable = true;
  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    tailscale.enable = true;
  };

  users.users.chris = {
    isNormalUser = true;
    description = "Chris Skalenda";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    home-manager
    gnumake
  ];

  system.stateVersion = "24.11";
}
