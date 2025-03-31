{ lib, pkgs, ... }:
{
  programs = {
    tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 10000;
      prefix = "C-a";

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
        }
      ];
      extraConfig = ''
        #set -g mouse on

        # Configure the catppuccin plugin
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_window_status_style "rounded"

        # Make the status line pretty and add some modules
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        #set -agF status-right "#{E:@catppuccin_status_cpu}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        #set -ag status-right "#{E:@catppuccin_status_uptime}"
        #set -agF status-right "#{E:@catppuccin_status_battery}"

        # Set the window text to be the window name
        set -g @catppuccin_window_text "#W"
        set -g @catppuccin_window_current_text "#W"
        set -g @catppuccin_window_default_text "#W"

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
