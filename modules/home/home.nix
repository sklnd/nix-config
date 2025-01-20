{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gh
      hub
      silver-searcher
      tig
      zsh-powerlevel10k
    ];
    stateVersion = "23.11";
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;
  };
}
