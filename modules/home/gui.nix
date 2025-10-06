{
  lib,
  pkgs,
  host,
  ...
}:
{
  home = {
    sessionPath = [
      # Temp hack until vscode is managed by home-manager
      "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"
    ];
  };

  xdg.configFile."wezterm/wezterm.lua".source = ../../config/wezterm/wezterm.lua;
  xdg.configFile."wezterm/appearance.lua".source = ../../config/wezterm/appearance.lua;
  programs.wezterm = {
    enable = true;
    enableZshIntegration = false;
  };

  xdg.configFile."sketchybar".source = ../../config/sketchybar;
}
