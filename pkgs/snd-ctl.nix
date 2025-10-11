{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "snd-ctl";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/sklnd/snd-ctl/releases/download/v${version}/snd-ctl-v${version}-macos.tar.gz";
    hash = "sha256-/9Ka1S2MtysmsMO9bRLNGjawPs4I9vnuvGXW3mKmZxY=";
  };

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ./snd-ctl $out/bin/snd-ctl

    runHook postInstall
  '';

  meta = with lib; {
    description = "A macOS command-line interface (CLI) tool for controlling media playback and retrieving track information";
    homepage = "https://github.com/sklnd/snd-ctl";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.darwin; # macOS only
  };
}
