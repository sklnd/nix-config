# Configuration and tooling for software development
{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      claude-code
      gcc
      jre
      overmind
      amazon-ecr-credential-helper
      argocd
      asdf-vm
      autoconf
      automake
      aws-vault
      bison
      cmake
      delta
      gh
      hub
      libtool
      mycli
      neovim-remote
      nginx
      nodejs
      pkg-config
      ripgrep
      rustup
      shfmt
      silver-searcher
      stylua
      tig
      tokei
    ];
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;
    mise.enable = true;
  };
}
