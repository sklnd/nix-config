{ lib, pkgs, ... }:
{
  home = {
    username = "chris.skalenda";
    homeDirectory = "/Users/chris.skalenda";
  };

  programs = {
    git = {
      userEmail = "chris.skalenda@joinhonor.com";
    };
    zsh = {
      initExtra = ''
        # Powerlevel10k Zsh theme
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source $HOME/.h4.zshrc
      '';

      shellAliases = {
        "h" = "honor";
        "sso" = "aws-vault exec default";
      };
    };
  };
}
