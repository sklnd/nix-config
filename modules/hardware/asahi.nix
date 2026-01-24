# Configuration necessary for MBP hardware
{pkgs, ...}: {
  # F keys active by default, fn to use alt function
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
