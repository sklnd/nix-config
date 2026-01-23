# Configuration necessary for MBP hardware
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
