{...}: {
  imports = [
    ./gui-darwin.nix
    ./gui-nixos.nix
  ];

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ../../config/wezterm/wezterm.lua;
    "wezterm/appearance.lua".source = ../../config/wezterm/appearance.lua;
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = false;
  };
}
