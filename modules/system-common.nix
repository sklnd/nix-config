{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    argocd
    asdf-vm
    autoconf
    automake
    aws-vault
    bison
    cmake
    gnumake
    home-manager
    libtool
    mise
    nginx
    pkg-config
    rustup
    shfmt
    stylua
    treefmt
    gnupg
    tokei
    deadnix
    statix
    alejandra
  ];
}
