{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gh
      hub
      silver-searcher
      tig
      zsh-powerlevel10k
      amazon-ecr-credential-helper
      nodejs
      delta
      ripgrep
      slides
      mycli
      nerd-fonts.jetbrains-mono
      aws-vault
      neovim-remote
    ];
    stateVersion = "23.11";
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;
  };
}
