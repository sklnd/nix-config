{pkgs, ...}: {
  imports = [
    ./applications.nix
    ./dev-tools.nix
  ];
  home = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    stateVersion = "23.11";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
