{
  pkgs,
  ...
}:
let
  machineDefs = import ./system.nix { };

in
{
  imports = [
    ./hardware-configuration.nix
    ./apple-silicon-support
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    nix-ld.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = machineDefs.hostname;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "thunderbolt"

      ];
      kernelModules = [
        "evdi"
      ];
    };
  };

  services = {
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
      videoDrivers = [ "displaylink" ];
    };

    tailscale.enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    gnome = {
      core-developer-tools.enable = false;
      games.enable = false;
      gnome-keyring.enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable touchpad support
    libinput.enable = true;

  };
  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    gdm-password.enableGnomeKeyring = true;
    hyprland.enableGnomeKeyring = true;
  };

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  users.users.chris = {
    isNormalUser = true;
    description = "Chris Skalenda";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    chromium
    displaylink
    gnumake
    home-manager
    monaspace
    protonvpn-gui
    signal-desktop
    vim
    vscode
    unzip
    gcc
    docker
    claude-code
    kitty

    # hyprland stuff
    wofi
    waybar
    playerctl
    bibata-cursors
    walker
  ];

  systemd.services = {
    dlm.wantedBy = [ "multi-user.target" ];
  };

  networking.firewall.checkReversePath = false;

  system.stateVersion = "25.11";
}
