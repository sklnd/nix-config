{pkgs, ...}: {
  home.packages = with pkgs;
    [
      ncdu
      slides
      bat
    ]
    # macos specific
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      mole-cleaner
    ]
    # nixos-specific
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      bluetui
    ];
}
