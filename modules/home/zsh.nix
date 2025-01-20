{ lib, pkgs, ... }:
{
  home = {
    file.".p10k.zsh".text = builtins.readFile ../../config/zsh/p10k.zsh;
    stateVersion = "23.11";
  };
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initExtraBeforeCompInit = builtins.readFile ../../config/zsh/zshrc;
      initExtraFirst = lib.mkDefault ''
        # Powerlevel10k Zsh theme
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "scd"
          "dotenv"
          "ssh-agent"
        ];
      };
    };
  };
}
