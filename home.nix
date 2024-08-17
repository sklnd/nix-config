{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello home-manager neovim
    ];
    username = "chris";
    homeDirectory = "/Users/chris";

    stateVersion = "23.11";
  };
}
