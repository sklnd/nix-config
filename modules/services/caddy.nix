{
  config,
  pkgs,
  ...
}: let
  tsDomain = "${config.networking.hostName}.tail51d48.ts.net";
  certDir = "/var/lib/tailscale-certs";
in {
  users.groups.tailscale-cert = {};
  users.users.caddy.extraGroups = ["tailscale-cert"];
  users.users.chris.extraGroups = ["tailscale-cert"];

  # Cert directory readable by the tailscale-cert group (which caddy is in).
  systemd.tmpfiles.rules = [
    "d ${certDir} 0750 root tailscale-cert -"
  ];

  systemd.services.tailscale-cert = {
    description = "Refresh Tailscale TLS certificate for Caddy";
    # tailscaled must be running before a certificate can be requested.
    after = ["tailscaled.service"];
    requires = ["tailscaled.service"];
    before = ["caddy.service"];
    wantedBy = ["caddy.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "tailscale-cert" ''
        set -euo pipefail

        ${pkgs.coreutils}/bin/install -d -m 0750 -o root -g tailscale-cert ${certDir}

        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file ${certDir}/${tsDomain}.crt \
          --key-file ${certDir}/${tsDomain}.key \
          ${tsDomain}

        ${pkgs.coreutils}/bin/chgrp tailscale-cert ${certDir}/${tsDomain}.crt ${certDir}/${tsDomain}.key
        ${pkgs.coreutils}/bin/chmod 0640 ${certDir}/${tsDomain}.crt ${certDir}/${tsDomain}.key
        ${pkgs.coreutils}/bin/chmod 0750 ${certDir}
      '';
    };
  };

  systemd.timers.tailscale-cert = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "24h";
    };
  };

  services.caddy = {
    enable = true;

    virtualHosts."${tsDomain}" = {
      extraConfig = ''
        tls ${certDir}/${tsDomain}.crt ${certDir}/${tsDomain}.key

        reverse_proxy localhost:3000
      '';
    };
  };
}
