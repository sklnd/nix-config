{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tmux
      zsh-powerlevel10k
    ];
    file.".p10k.zsh".text = builtins.readFile ./p10k.zsh;
    stateVersion = "23.11";
  };
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
      ];
    };

    git = {
      enable = true;
      userName = "Chris Skalenda";
      userEmail = lib.mkDefault "chris@skalenda.org";
      aliases = {
        "co" = "checkout";
      };
      extraConfig = {
        "user" = {
          signingkey = "/Users/chris/.ssh/2021-ecdsa";
        };
        "core" = {
          editor = "vim";
          autocrlf = false;
          excludesfile = "~/.git_global_ignore";
        };
        "push" = {
          default = "current";
        };
        "color" = {
          "status" = {
            added = "green bold";
            changed = "red bold strike";
            untracked = "cyan";
            branch = "yellow black bold ul";
          };
        };
        "pull" = {
          ff = "only";
        };
        "filter" = {
          "lfs" = {
            clean = "git-lfs clean -- %f";
            smudge = "git-lfs smudge -- %f";
            process = "git-lfs filter-process";
            required = true;
          };
        };
        "init" = {
          defaultBranch = "main";
        };
        "gpg" = {
          format = "ssh";
        };
      };
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initExtraBeforeCompInit = builtins.readFile ./zshrc;
      initExtra = ''
        # Powerlevel10k Zsh theme
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };
  };

}
