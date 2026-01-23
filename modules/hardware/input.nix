{pkgs, ...}: {
  # Touchpad support
  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    libinput
  ];
}
