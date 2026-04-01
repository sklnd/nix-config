{
  pkgs,
  lib,
  ...
}: {
  options = {
    enable = false;
  };

  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    xdg.configFile."sketchybar".source = ../../config/sketchybar;
    programs.wezterm.enable = true;
    home.sessionPath = [
      # Temp hack until vscode is managed by home-manager
      "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"
    ];
  };
}
