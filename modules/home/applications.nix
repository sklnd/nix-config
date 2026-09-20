{pkgs, ...}: {
  home.packages = with pkgs;
    [
      ncdu
      slides
      bat
    ]
    # macos specific
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ]
    # nixos-specific
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      bluetui
    ];
}
