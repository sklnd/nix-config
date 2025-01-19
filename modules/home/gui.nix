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
}
