{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    rofi
    waybar
    hyprpanel
    hyprlock
    hypridle
    playerctl
    bibata-cursors
  ];

  security.pam.services = {
    hyprland.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
  };

}
