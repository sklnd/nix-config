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

      # agent things
      claude-code
      opencode
    ];
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;
    mise.enable = true;
  };
}
