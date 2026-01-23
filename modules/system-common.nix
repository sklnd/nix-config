{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alejandra
    argocd
    asdf-vm
    autoconf
    automake
    aws-vault
    bison
    cmake
    deadnix
    gnumake
    gnupg
    home-manager
    killall
    libtool
    mise
    nginx
    pkg-config
    rustup
    shfmt
    statix
    stylua
    tokei
    treefmt
  ];
}
