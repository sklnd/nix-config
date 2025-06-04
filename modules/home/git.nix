{ lib, pkgs, ... }:
{

  programs = {
    jujutsu = {
      enable = true;
      settings = {

        user = {
          email = lib.mkDefault "chris@skalenda.org";
          name = "Chris Skalenda";
        };
        ui = {
          default-command = "log";
          editor = "nvim";
        };
      };
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
  };
}
