{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gh
      hub
      silver-searcher
      tig
      zsh-powerlevel10k
    ];
    stateVersion = "23.11";
  };

  programs = {
    awscli.enable = true;
    direnv.enable = true;

    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 10000;
      prefix = "C-a";

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = power-theme;
          extraConfig = ''
            		   set -g @tmux_power_theme 'moon'
            		'';
        }
      ];
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
