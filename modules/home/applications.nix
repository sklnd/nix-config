{pkgs, ...}: {
  home.packages = with pkgs;
    [
      ncdu
      slides
    ]
    # macos specific
    ++ lib.optionals stdenv.isDarwin [
    ]
    # nixos-specific
    ++ lib.optionals (!stdenv.isDarwin) [
      bluetui
    ];
}
