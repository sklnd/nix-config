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
    gpg.enable = true;
    zsh = {
      initExtra = ''
        source $HOME/.h4.zshrc
      '';

      shellAliases = {
        "h" = "honor";
        "sso" = "aws-vault exec default";
      };
    };
  };
}
