{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tmux
      tig
      zsh-powerlevel10k
    ];
    file.".p10k.zsh".text = builtins.readFile ./p10k.zsh;
    stateVersion = "23.11";
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    #   vimdiffAlias = true;
    #   plugins = with pkgs.vimPlugins; [
    #     nvim-lspconfig
    #     nvim-treesitter.withAllGrammars
    #   ];
    # };

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
      initExtra = lib.mkDefault ''
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

    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 10000;
      prefix = "C-a";

      extraConfig = ''
        # Highlight active window
        #set-window-option -g window-status-current-bg black
        #set-window-option -g window-status-current-fg white
        setw -g window-status-current-style fg=white,bg=black

        # Activity monitoring
        setw -g monitor-activity on
        set -g visual-activity on

        # hjkl pane traversal
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # reload config
        bind r source-file ~/.tmux.conf \; display-message "Config reloaded..."
        unbind C-b

        #open man page with /
        bind / command-prompt "split-window -h 'exec man %%'"

        # title A
        unbind A
        bind A command-prompt "rename-window %%"

        # Toggle mouse on
        bind m \
          set -g mouse on \;\
          display 'Mouse: ON'

        # Toggle mouse off
        bind M \
          set -g mouse off \;\
          display 'Mouse: OFF'

        # Make easy to remember split bindings
        bind | split-window -h
        bind - split-window -v

        set -g default-command ${pkgs.zsh}/bin/zsh

      '';
    };
  };

}
