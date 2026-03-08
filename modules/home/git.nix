{lib, ...}: {
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Chris Skalenda";
          email = lib.mkDefault "chris@skalenda.org";
        };
        ui = {
          default-command = "log";
          editor = "nvim";
          pager = "delta";
        };
        git = {
          write-change-id-header = true;
        };
        remotes.origin = {
          auto-track-created-bookmarks = "*";
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
      settings = {
        user = {
          name = "Chris Skalenda";
          email = lib.mkDefault "chris@skalenda.org";
        };
        aliase = {
          "co" = "checkout";
        };
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
    };
  };
}
