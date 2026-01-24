{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [
      chromium
      dbvisualizer
      firefox
      gimp
      kitty
      protonvpn-gui
      signal-desktop
    ];

    xdg.configFile = {
      "kitty/kitty.conf".source = ../../config/kitty/kitty.conf;
      "kitty/material-darker.conf".source = ../../config/kitty/material-darker.conf;
      "kitty/iterm2-ligth.conf".source = ../../config/kitty/iterm2-light.conf;
      "hypr/hyprland.conf".source = ../../config/hypr/hyprland.conf;
      "hypr/hyprlock.conf".source = ../../config/hypr/hyprlock.conf;
      "hypr/hypridle.conf".source = ../../config/hypr/hypridle.conf;
    };

    programs.vscode.enable = true;
  };
}
