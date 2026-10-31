# Configuration and tooling for software development
{
  config,
  lib,
  pkgs,
  llm-agents,
  ...
}: let
  cfg = config.sk.home.devTools;
in {
  options.sk.home.devTools.installCommonPackages = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install common development tools when they are not supplied by the system.";
  };

  config = {
    home.packages = with pkgs;
    with llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      [
        aws-vault
        delta
        hub
        jq
        jre
        mycli
        neovim-remote
        ngrok
        ollama
        postgresql
        qemu
        rustup
        stylua
        tig
        tilt
        tokei

        (pkgs.callPackage ../../pkgs/vendored/plannotator.nix {})
      ]
      ++ lib.optionals cfg.installCommonPackages [
        autoconf
        automake
        bison
        cmake
        fd
        gh
        grpcurl
        libtool
        pkg-config
        ripgrep
        shfmt
        yq
        xz
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        gcc # Darwin uses Xcode's tools.
      ];

    programs = {
      awscli.enable = true;
      direnv.enable = true;
      mise = {
        enable = true;
        globalConfig = {
          settings = {
            experimental = true;
            activate_aggressive = true;
          };
          tools = {
            node = "24";
            uv = "0.13.5";
          };
          settings.pipx.uvx = true;
        };
      };
    };
  };
}
