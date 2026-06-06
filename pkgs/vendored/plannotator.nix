{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  git,
  xdg-utils,
}: let
  version = "0.19.24";
  artifacts = {
    x86_64-linux = {
      name = "plannotator-linux-x64";
      hash = "sha256-sJawfWX+H1IBt63u0bkAx5rBXcMDj4f0MzY6hl/JJMs=";
    };
    aarch64-darwin = {
      name = "plannotator-darwin-arm64";
      hash = "sha256-1qjmlGdredKGdQm94OjuWf5Wc0KaasRuzfp0aur22Ws=";
    };
    aarch64-linux = {
      name = "plannotator-linux-arm64";
      hash = "sha256-oX2S5Hz45LRt5RPCTxttuTtQgTTlFj0l4kpMq2I21Tc=";
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
