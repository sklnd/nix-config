{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.sk.home.sshAgent;
in {
  options.sk.home.sshAgent = {
    enable = lib.mkEnableOption "using Proton Pass as the SSH agent";

    socketPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.ssh/proton-pass-ssh-agent.sock";
      description = "Path to the SSH agent socket exported as SSH_AUTH_SOCK.";
    };
  };

  config = {
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
          (lib.mkOrder 1000 (lib.optionalString cfg.enable ''
            export SSH_AUTH_SOCK=${cfg.socketPath}
          ''))
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
  };
}
