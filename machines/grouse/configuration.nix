{pkgs, ...}: let
  machineDefs = import ./system.nix {};
in {
  imports = [
    ./hardware-configuration.nix
    ./apple-silicon-support
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/gnome.nix

    ../../modules/system/boot-asahi.nix
    ../../modules/system/display-manager.nix
    ../../modules/system/fonts.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking-nixos.nix
    ../../modules/system/nix.nix
    ../../modules/system/users.nix

    ../../modules/services/audio.nix
    ../../modules/services/docker.nix
    ../../modules/services/xserver.nix

    ../../modules/hardware/asahi.nix
    ../../modules/hardware/displaylink.nix
    ../../modules/hardware/input.nix
    ../../modules/hardware/moonlander.nix
  ];

  programs = {
    firefox = {
      enable = true;
      nativeMessagingHosts.packages = [pkgs.firefoxpwa];
    };
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  networking.hostName = machineDefs.hostname;

  # systemd.targets.sleep.enable = true;
  # systemd.targets.suspend.enable = true;
  # systemd.targets.hibernate.enable = true;
  # systemd.targets.hybrid-sleep.enable = true;

  services = {
    dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];

    # Force systemd to suspend when lid is closed
    # logind = {
    #   lidSwitch = "suspend";
    #   lidSwitchExternalPower = "suspend";
    # };
  };

  security.pam.services = {
    login.enableGnomeKeyring = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Misc
      firefoxpwa
      libsecret
      pinentry-curses
      pinentry-gnome3
    ];
    variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  };

  systemd.services = {
    dlm.wantedBy = ["multi-user.target"];
  };

  system.stateVersion = "25.11";
}
