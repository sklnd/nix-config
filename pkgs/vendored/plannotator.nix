{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}: let
  version = "0.21.4";
  artifacts = {
    x86_64-linux = {
      name = "plannotator-linux-x64";
      hash = "sha256-19wZGFRAvQfXNWgwlAsFJoFhLyUhSFi+068bcv0asuA=";
    };
    aarch64-darwin = {
      name = "plannotator-darwin-arm64";
      hash = "sha256-Bhx62zgqwgT0B0h7PQ/EmjWJt5CLhtUw2Jba6rep720=";
    };
    aarch64-linux = {
      name = "plannotator-linux-arm64";
      hash = "sha256-/EG+jPtnPUTrmi6xfgShJc58tp8EmDayILk4tKYFsIs=";
    };
  };
  system = stdenv.hostPlatform.system;
  artifact =
    artifacts.${system}
    or (throw "Unsupported system for plannotator: ${system}");
in
  stdenv.mkDerivation rec {
    pname = "plannotator";
    inherit version;

    src = fetchurl {
      url = "https://github.com/backnotprop/plannotator/releases/download/v${version}/${artifact.name}";
      hash = "${artifact.hash}";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 $src $out/bin/plannotator

      runHook postInstall
    '';

    meta = {
      description = "Interactive plan review for AI coding agents";
      homepage = "https://plannotator.ai";
      license = with lib.licenses; [
        mit
        asl20
      ];
      platforms = builtins.attrNames artifacts;
      mainProgram = "plannotator";
    };
  }
