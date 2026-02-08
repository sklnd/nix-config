{
  config,
  pkgs,
  ...
}: {
  users.groups.tailscale-cert = {};
  users.users.caddy.extraGroups = ["tailscale-cert"];
  users.users.chris.extraGroups = ["tailscale-cert"];

  # Ensure cert directory + keys readable by the group
  systemd.tmpfiles.rules = [
    "d /var/lib/tailscale/certs 0750 root tailscale-cert -"
    "Z /var/lib/tailscale/certs - - - -"
  ];

  systemd.services.tailscale-cert = {
    description = "Refresh Tailscale TLS cert";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "tailscale-cert" ''
        ${pkgs.tailscale}/bin/tailscale cert ${config.networking.hostName}.tail51d48.ts.net.crt
        chgrp tailscale-cert /var/lib/tailscale/certs/*
        chmod 660 /var/lib/tailscale
        chmod 660 /var/lib/tailscale/certs
        chmod 640 /var/lib/tailscale/certs/*.key
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

    virtualHosts."${config.networking.hostName}.tail51d48.ts.net" = {
      extraConfig = ''
        tls /var/lib/tailscale/certs/${config.networking.hostName}.tail51d48.ts.net.crt \
          /var/lib/tailscale/certs/${config.networking.hostName}.tail51d48.ts.net.key

        reverse_proxy localhost:3000
      '';
    };
  };
}
