{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}: let
  version = "0.27.4";
  artifacts = {
    x86_64-linux = {
      name = "plannotator-linux-x64";
      hash = "sha256-6tHSdH1uWFYRm8lCpufmyFH2czh6P1Z+cyKm2TseHLA=";
    };
    aarch64-darwin = {
      name = "plannotator-darwin-arm64";
      hash = "sha256-1xvt/TWHyXU+DQuR0i3NthnYBIjqWum0WaxvNGIdfPE=";
    };
    aarch64-linux = {
      name = "plannotator-linux-arm64";
      hash = "sha256-dK8rNWMmUH1LZX5N5r7cmXtdDMjKjEGeWSn2wc1uW3Y=";
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
