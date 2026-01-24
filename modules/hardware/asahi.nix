# Configuration necessary for MBP hardware
{pkgs, ...}: {
  # F keys active by default, fn to use alt function
  boot = {
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';

    kernel.sysctl = {
      # Max brightness is 255.
      "class.leds.kbd_backlight.brightness" = 100;
    };
  };
  environment.systemPackages = with pkgs; [
    brightnessctl # screen backlight
  ];
}
