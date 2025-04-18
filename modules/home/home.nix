{ lib, pkgs, ... }:
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
      nixfmt-rfc-style
      treefmt
      stylua
    ];
    stateVersion = "23.11";
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;
  };
}
