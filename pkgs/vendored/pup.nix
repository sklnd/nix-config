{
  lib,
  fetchurl,
  stdenvNoCC,
}: let
  version = "0.50.2";

  artifacts = {
    x86_64-linux = {
      name = "pup_${version}_Linux_x86_64.tar.gz";
      hash = "sha256-iA3D0xVN7aJJPaDPVi8YhyE/C2V5ba8AEafhL/vI8Qw=";
    };
    aarch64-linux = {
      name = "pup_${version}_Linux_arm64.tar.gz";
      hash = "sha256-xMbZq4TtpBYDCq79tVV2odhhEfkJmoh/nkKZ2bJ9dGc=";
    };
    x86_64-darwin = {
      name = "pup_${version}_Darwin_x86_64.tar.gz";
      hash = "sha256-Xn9bGlr7vcMiDKy/Dq5z70xkNmpAUP/kyl7pQVk7/y8=";
    };
    aarch64-darwin = {
      name = "pup_${version}_Darwin_arm64.tar.gz";
      hash = "sha256-+aF8lJeOt8XjptvLsOGDlHoAzKHndytJoVFoOeRUmhE=";
    };
  };

  system = stdenvNoCC.hostPlatform.system;
  artifact =
    artifacts.${system}
    or (throw "Unsupported system for pup: ${system}");
in
  stdenvNoCC.mkDerivation {
    pname = "pup";
    inherit version;

    src = fetchurl {
      url = "https://github.com/datadog-labs/pup/releases/download/v${version}/${artifact.name}";
      inherit (artifact) hash;
    };

    dontConfigure = true;
    dontBuild = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      test -f pup
      install -Dm755 pup $out/bin/pup

      runHook postInstall
    '';

    meta = {
      description = "CLI companion for Datadog workflows";
      homepage = "https://github.com/datadog-labs/pup";
      license = lib.licenses.asl20;
      mainProgram = "pup";
      platforms = builtins.attrNames artifacts;
    };
  }
