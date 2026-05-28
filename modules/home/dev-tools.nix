# Configuration and tooling for software development
{
  pkgs,
  llm-agents,
  ...
}: {
  home = {
    packages = with pkgs;
    with llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      [
        amazon-ecr-credential-helper
        # argocd
        acli
        autoconf
        automake
        aws-vault
        bison
        cmake
        delta
        fd
        gh
        grpcurl
        hub
        jre
        libtool
        mycli
        neovim-remote
        nginx
        ngrok
        ollama
        pkg-config
        postgresql
        qemu
        ripgrep
        rustup
        shfmt
        silver-searcher
        stylua
        temporal-cli
        tig
        tilt
        tokei
        yq
        xz

        # things for gondolin
        e2fsprogs
        lz4

        # agent things
        claude-code
        github-copilot-cli
        rtk

        (pkgs.callPackage ../../pkgs/vendored/argocd.nix {})
        (pkgs.callPackage ../../pkgs/vendored/asdf-vm.nix {})
        (pkgs.callPackage ../../pkgs/vendored/gws.nix {})
        (pkgs.callPackage ../../pkgs/vendored/pup.nix {})
        (pkgs.callPackage ../../pkgs/vendored/td.nix {})
      ]
      # nixos-specific
      ++ lib.optionals (!stdenv.isDarwin) [
        gcc # Use xcode-tools.
      ];
  };

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
        };
      };
    };
  };

  xdg.configFile = {
    "opencode/opencode.jsonc".source = ../../config/opencode/opencode.jsonc;
  };
}
