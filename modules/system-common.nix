{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager

    # core cli tools
    coreutils
    dig
    dnsutils
    gnupg
    gnutar
    inetutils
    killall
    unixtools.netstat
    unzip
    zip

    # Required for nix repo development
    alejandra
    deadnix
    gnumake
    statix
    treefmt
  ];

  programs.zsh.enable = true;
}
