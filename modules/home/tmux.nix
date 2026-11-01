{pkgs, ...}: {
  programs = {
    tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 10000;
      prefix = "C-a";

      extraConfig = ''
        # Let WezTerm's transparent background show between the islands.
        set -g status-style "bg=default,fg=#cad3f5"
        set -g status-left ""
        set -g status-right-length 100
        set -g window-status-separator " "
        set -g window-status-format "#[fg=#24273a,bg=default]#[fg=#a5adcb,bg=#24273a]#I #W#[fg=#24273a,bg=default]"
        set -g window-status-current-format "#[fg=#363a4f,bg=default]#[fg=#c29df1,bg=#363a4f,bold]#I #W#[fg=#363a4f,bg=default,nobold]"
        set -g window-status-activity-style "fg=#c29df1,bg=default,bold"
        set -g window-status-bell-style "fg=#eed49f,bg=default,bold"

        set -g status-right "#[none,fg=#363a4f,bg=default]#[fg=#c29df1,bg=#363a4f] #[fg=#cad3f5]#{pane_current_command}#[fg=#363a4f,bg=default] "
        set -ag status-right "#[fg=#363a4f,bg=default]#[fg=#{?client_prefix,#ed8796,#c29df1},bg=#363a4f] #[fg=#cad3f5]#S#[fg=#363a4f,bg=default]"

        # shortcut: app-defined colors stay unchanged, use dim= once the server supports tmux 3.8.
        set -g window-style "fg=#8087a2,bg=default"
        set -g window-active-style "fg=#cad3f5,bg=default"

        # Make the active pane obvious without a bright background.
        set -g pane-border-style "fg=#363a4f"
        set -g pane-active-border-style "fg=#c29df1,bold"

        # Show a marker and the pane title on the top border of each pane
        set -g pane-border-status top
        set -g pane-border-format "#{?pane_active,#[fg=#c29df1,bold]▶ ,  }#[fg=#a5adcb]#{pane_index}: #{pane_title}"
        set -g message-style "fg=#cad3f5,bg=#363a4f"
        set -g message-command-style "fg=#cad3f5,bg=#363a4f"
        set -g mode-style "fg=#cad3f5,bg=#363a4f,bold"
        set -g menu-selected-style "fg=#c29df1,bg=#363a4f,bold"
        set -g popup-style "fg=#cad3f5,bg=#181926"
        set -g popup-border-style "fg=#494d64"
        set -g clock-mode-colour "#c29df1"

        # Activity monitoring
        setw -g monitor-activity on
        set -g visual-activity on

        # hjkl pane traversal
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # reload config
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

        unbind C-b

        #open man page with /
        bind / command-prompt "split-window -h 'exec man %%'"

        # title A
        unbind A
        bind A command-prompt "rename-window %%"


        # Default mouse on
        set -g mouse on
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

        set -g extended-keys on
        set -g extended-keys-format csi-u

        set -g default-command ${pkgs.zsh}/bin/zsh
      '';
    };
  };
}
