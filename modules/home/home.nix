{pkgs, ...}: {
  imports = [
    ./applications.nix
    ./dev-tools.nix
    ./pi.nix
  ];
  home = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    stateVersion = "23.11";

    shellAliases = {
      ls = "ls --color";
      cat = "bat";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
