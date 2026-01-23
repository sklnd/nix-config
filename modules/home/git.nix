{lib, ...}: {
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
          #editor = "nvr -cc split --remote-wait +'setlocal bufhidden=wipe'";
          editor = "nvr --remote-wait";
          pager = "delta";
        };
        git = {
          write-change-id-header = true;
        };
        aliases = {
          tug = [
            "bookmark"
            "move"
            "--from"
            "heads(::@- & bookmarks())"
            "--to"
            "@-"
          ];
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
      ignores = [
        # Macos
        ".DS_Store"

        # Windows
        "Thumbs.db"
        "ehthumbs.db"
        "Desktop.ini"

        # Local files
        "mise.local.toml"
        ".mise.local.toml"
        ".envrc.local"

        # Misc
        "*.log"

        # Node
        "node_modules/"

        # Python
        ".__pycache__/"
        "*.pyc"
        "*.pyo"

        # VIM
        "*.swp"
        "*.swo"

        # Compiled files
        "*.out"
        "*.class"
        "*.exe"
        "*.dll"
        "*.o"
        "*.so"
      ];
      extraConfig = {
        "user" = {
          signingkey = "/Users/chris/.ssh/2021-ecdsa";
        };
        "core" = {
          editor = "vim";
          autocrlf = false;
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
