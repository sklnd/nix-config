{
  lib,
  pkgs,
  config,
  ...
}: {
  home = {
    file.".p10k.zsh".text = builtins.readFile ../../config/zsh/p10k.zsh;
    packages = with pkgs; [
      zsh-powerlevel10k
    ];
  };

  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          # Powerlevel10k Zsh theme
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        '')
        (lib.mkOrder 550 (builtins.readFile ../../config/zsh/zshrc))
        (
          lib.mkOrder 1000 ''
            export SSH_AUTH_SOCK=/Users/chris/.ssh/proton-pass-ssh-agent.sock
          ''
        )
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "scd"
          "dotenv"
        ];
      };
    };
  };
}
