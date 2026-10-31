{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sk.system;
in {
  options.sk.system.installCommonTools = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install common command-line tools when they are not supplied by another system module.";
  };

  config = {
    # Preserve the personal package order; composed hosts can omit system-provided tools.
    environment.systemPackages = with pkgs;
      [home-manager]
      ++ lib.optionals cfg.installCommonTools [
        coreutils
        dig
        dnsutils
        gnupg
        gnutar
      ]
      ++ [
        inetutils
        killall
        unixtools.netstat
      ]
      ++ lib.optionals cfg.installCommonTools [
        unzip
        zip
        alejandra
        deadnix
        gnumake
        statix
      ]
      ++ [treefmt];

    programs.zsh.enable = true;
  };
}
