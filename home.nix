{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      neovim tmux
    ];
    username = "chris";
    homeDirectory = "/Users/chris";

    stateVersion = "23.11";
  };
}
