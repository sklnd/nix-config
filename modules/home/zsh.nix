{
  lib,
  pkgs,
  ...
}: {
  home = {
    file.".p10k.zsh".text = builtins.readFile ../../config/zsh/p10k.zsh;
    stateVersion = "23.11";
  };
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          # Powerlevel10k Zsh theme
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        '')
        (lib.mkOrder 550 (builtins.readFile ../../config/zsh/zshrc))
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "scd"
          "dotenv"
          #"ssh-agent"
        ];
      };
    };
  };
}
