{pkgs, ...}: {
  imports = [
    ./dev-tools.nix
  ];
  home = {
    packages = with pkgs; [
      zsh-powerlevel10k
      slides
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
