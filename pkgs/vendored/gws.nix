{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
}: let
  version = "0.22.5";

  artifacts = {
    x86_64-linux = {
      name = "google-workspace-cli-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-3njs29LxqEzKAGOn7LxEAkD8FLbrzLsX9GRreSqMXB8=";
    };
    aarch64-linux = {
      name = "google-workspace-cli-aarch64-unknown-linux-gnu.tar.gz";
      hash = "sha256-lEkCldlYDh6IV05xWgoWKZF0fRLWL4x7jcyCaLbBzqA=";
    };
    x86_64-darwin = {
      name = "google-workspace-cli-x86_64-apple-darwin.tar.gz";
      hash = "sha256-Ufm9cxQE1LuibDbi4w3WjFbczR+DTAElLLCxTWplRLI=";
    };
    aarch64-darwin = {
      name = "google-workspace-cli-aarch64-apple-darwin.tar.gz";
      hash = "sha256-HSqf/VvJssLEtIYw2vCC+tE9nlfXQZiKLCSO7VYvfaw=";
    };
  };

  system = stdenv.hostPlatform.system;
  artifact =
    artifacts.${system}
    or (throw "Unsupported system for gws: ${system}");
in
  stdenv.mkDerivation {
    pname = "gws";
    inherit version;

    src = fetchurl {
      url = "https://github.com/googleworkspace/cli/releases/download/v${version}/${artifact.name}";
      inherit (artifact) hash;
    };

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [autoPatchelfHook];
    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [stdenv.cc.cc.lib];

    dontConfigure = true;
    dontBuild = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      test -f gws
      install -Dm755 gws $out/bin/gws

      runHook postInstall
    '';

    meta = {
      description = "Google Workspace CLI";
      homepage = "https://github.com/googleworkspace/cli";
      license = lib.licenses.asl20;
      mainProgram = "gws";
      platforms = builtins.attrNames artifacts;
    };
  }
