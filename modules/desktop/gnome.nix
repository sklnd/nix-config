{pkgs, ...}: {
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];
  };

  services = {
    desktopManager.gnome.enable = true;

    gnome = {
      core-developer-tools.enable = false;
      games.enable = false;
      gnome-keyring.enable = true;
    };
  };
}
