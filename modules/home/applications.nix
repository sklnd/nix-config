{pkgs, ...}: {
  home.packages = with pkgs;
    [
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
