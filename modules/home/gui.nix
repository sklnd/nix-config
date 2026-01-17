_: {
  home = {
    sessionPath = [
      # Temp hack until vscode is managed by home-manager
      "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"
    ];
  };

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ../../config/wezterm/wezterm.lua;
    "wezterm/appearance.lua".source = ../../config/wezterm/appearance.lua;
    "kitty/kitty.conf".source = ../../config/kitty/kitty.conf;
    "kitty/material-darker.conf".source = ../../config/kitty/material-darker.conf;
    "kitty/iterm2-ligth.conf".source = ../../config/kitty/iterm2-light.conf;
    "hypr/hyprland.conf".source = ../../config/hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ../../config/hypr/hyprlock.conf;
    "hypr/hypridle.conf".source = ../../config/hypr/hypridle.conf;
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = false;
  };

  xdg.configFile."sketchybar".source = ../../config/sketchybar;
}
