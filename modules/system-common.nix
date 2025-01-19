{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    home-manager
    gnumake
    treefmt
    shfmt
    asdf-vm
    aws-vault
  ];

}
