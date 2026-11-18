{pkgs, ...}: {
  programs = {
    # Run binaries from the internet (mise, uv) in nixos
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # python deps
        libgcc
        zlib

        # node deps
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
