{ lib, pkgs, ... }:
{
  home = {
    username = "chris.skalenda";
    homeDirectory = "/Users/chris.skalenda";
  };

  programs = {
    git = {
      userEmail = "chris.skalenda@joinhonor.com";
    };
  };
}
