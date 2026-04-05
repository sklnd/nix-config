{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_24,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gondolin";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "earendil-works";
    repo = "gondolin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ABDmbpFk+KDoCVmvF9+k+7Xo4+0iM0JFBaQbriLq24Q=";
  };

  pnpmWorkspaces = ["@earendil-works/gondolin"];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src pnpmWorkspaces;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-jLF4vtI6EadynUdox7a4QtQP2/0tytgV7CXqDROOhLQ=";
  };

  # pnpmConfigHook (configure phase) runs before buildPhase, but it tries to
  # create the gondolin bin wrapper which requires dist/bin/cli.js to exist.
  # Create stubs so pnpm can wire up .bin/gondolin; the real build overwrites them.
  postPatch = ''
    mkdir -p host/dist/bin
    printf '#!/usr/bin/env node\n' > host/dist/bin/cli.js
    printf '#!/usr/bin/env node\n' > host/dist/bin/gondolin.js
  '';

  nativeBuildInputs = [
    nodejs_24
    pnpm_9
    pnpmConfigHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm --filter=@earendil-works/gondolin build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/bin

    # Preserve full workspace layout so all pnpm symlinks resolve:
    #   node_modules/@earendil-works/gondolin -> ../../host
    #   host/node_modules/* -> ../../node_modules/.pnpm/...
    #   host/node_modules/@earendil-works/* -> ../../../packages/...
    cp -r host node_modules packages $out/lib/

    makeWrapper ${nodejs_24}/bin/node $out/bin/gondolin \
      --add-flags "$out/lib/host/dist/bin/gondolin.js"
    runHook postInstall
  '';

  meta = {
    description = "Alpine Linux sandbox for running untrusted code with controlled filesystem and network access";
    homepage = "https://earendil-works.github.io/gondolin/";
    license = lib.licenses.asl20;
    mainProgram = "gondolin";
    platforms = lib.platforms.unix;
  };
})
