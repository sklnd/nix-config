{
  lib,
  fetchurl,
  stdenvNoCC,
}: let
  version = "0.43.0";

  artifacts = {
    x86_64-linux = {
      name = "td_${version}_linux_amd64.tar.gz";
      hash = "sha256-feAWJ9zf7zK9LHdmfHrXSWU7jjNHLeIlg4UcEOGaHw4=";
    };
    aarch64-linux = {
      name = "td_${version}_linux_arm64.tar.gz";
      hash = "sha256-FxC8JHcsRXgjwgf9r8501AVj+IQ0r8vU0VKPGXddThs=";
    };
    x86_64-darwin = {
      name = "td_${version}_darwin_amd64.tar.gz";
      hash = "sha256-ZMyK2PBN3sZW9Epj9QxqGGiNG/ZZm/c3B/V8hA1jvsw=";
    };
    aarch64-darwin = {
      name = "td_${version}_darwin_arm64.tar.gz";
      hash = "sha256-uvwcafU92udmJoYi8Hf30ppNA/OiOG2EOLuMUPIkThA=";
    };
  };

  system = stdenvNoCC.hostPlatform.system;
  artifact =
    artifacts.${system}
    or (throw "Unsupported system for td: ${system}");
in
  stdenvNoCC.mkDerivation {
    pname = "td";
    inherit version;

    src = fetchurl {
      url = "https://github.com/marcus/td/releases/download/v${version}/${artifact.name}";
      inherit (artifact) hash;
    };

    dontConfigure = true;
    dontBuild = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      test -f td
      install -Dm755 td $out/bin/td

      runHook postInstall
    '';

    meta = {
      description = "A tiny CLI to manage todos locally";
      homepage = "https://github.com/marcus/td";
      license = lib.licenses.mit;
      mainProgram = "td";
      platforms = builtins.attrNames artifacts;
    };
  }
