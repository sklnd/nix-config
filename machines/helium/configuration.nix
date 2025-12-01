{pkgs, ...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ./hardware-configuration.nix
    (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "09j4kvsxw1d5dvnhbsgih0icbrxqv90nzf0b589rb5z6gnzwjnqf";
    })
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

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    openssh = {
      enable = true;
      ports = [22];
      authorizedKeysInHomedir = true;
      settings = {
        PasswordAuthentication = false;
        AllowUsers = ["chris"];
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
    };

    tailscale.enable = true;
    vscode-server.enable = true;
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
