# Configuration and tooling for software development
{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      amazon-ecr-credential-helper
      argocd
      asdf-vm
      autoconf
      automake
      aws-vault
      bison
      claude-code
      cmake
      delta
      gcc
      gh
      hub
      jre
      libtool
      mycli
      neovim-remote
      nginx
      ngrok
      nodejs
      overmind
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
