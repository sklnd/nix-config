{pkgs, ...}: {
  home.packages = with pkgs;
    [
      ncdu
      slides
      bat
    ]
    # macos specific
    ++ lib.optionals stdenv.isDarwin [
    ]
    # nixos-specific
    ++ lib.optionals (!stdenv.isDarwin) [
      bluetui
    ];
}
