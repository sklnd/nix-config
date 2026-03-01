# Configuration and tooling for software development
{pkgs, ...}: {
  home = {
    packages = with pkgs;
      [
        amazon-ecr-credential-helper
        # argocd
        autoconf
        automake
        aws-vault
        bison
        cmake
        delta
        gh
        grpcurl
        hub
        jre
        libtool
        mycli
        neovim-remote
        nginx
        ngrok
        nodejs
        overmind
        pkg-config
        postgresql
        ripgrep
        rustup
        shfmt
        silver-searcher
        stylua
        temporal-cli
        tig
        tilt
        tokei
        xz

        # agent things
        claude-code
        opencode
        github-copilot-cli

        (pkgs.callPackage ../../pkgs/vendored/argocd.nix {})
        (pkgs.callPackage ../../pkgs/vendored/asdf-vm.nix {})
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
      };
    };
  };

  xdg.configFile."opencode/opencode.jsonc".source = ../../config/opencode/opencode.jsonc;
}
