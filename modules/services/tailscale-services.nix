{
  lib,
  pkgs,
  ...
}: let
  # Each entry becomes https://<name>.<tailnet>.ts.net.
  upstreams = {
    grafana = "http://127.0.0.1:3000";
    homeassistant = "http://127.0.0.1:8123";
  };
in {
  services.tailscale.authKeyFile = "/etc/secrets/tailscale-authkey";

  systemd.tmpfiles.rules = [
    "d /etc/secrets 0700 root root -"
  ];

  systemd.services.tailscale-serve = {
    description = "Advertise Tailscale Services for local servers";
    after = ["tailscaled.service" "tailscaled-autoconnect.service"];
    wants = ["tailscaled.service" "tailscaled-autoconnect.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = lib.concatMapStrings (name: ''
      ${pkgs.tailscale}/bin/tailscale serve --service=svc:${name} --https=443 --yes ${upstreams.${name}}
    '') (lib.attrNames upstreams);
  };
}
