{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = with pkgs; [
      chromium
      dbvisualizer
      firefox
      gimp
      kitty
      protonvpn-gui
      (symlinkJoin {
        name = "signal-desktop";
        paths = [signal-desktop];
        nativeBuildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram "$out/bin/signal-desktop" --add-flags "--password-store=gnome-libsecret"
        '';
      })
    ];

    xdg.configFile = {
      "kitty/kitty.conf".source = ../../config/kitty/kitty.conf;
      "kitty/material-darker.conf".source = ../../config/kitty/material-darker.conf;
      "kitty/iterm2-light.conf".source = ../../config/kitty/iterm2-light.conf;
      "hypr/hyprland.conf".source = ../../config/hypr/hyprland.conf;
      "hypr/hyprlock.conf".source = ../../config/hypr/hyprlock.conf;
      "hypr/hypridle.conf".source = ../../config/hypr/hypridle.conf;
    };

    programs.vscode.enable = true;
  };
}
