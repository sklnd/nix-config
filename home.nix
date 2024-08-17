{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tmux
    ];
    username = "chris";
    homeDirectory = "/Users/chris";

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
      userEmail = "chris@skalenda.org";
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
  };
}
