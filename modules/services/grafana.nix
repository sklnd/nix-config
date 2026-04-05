{config, ...}: {
  services.grafana = {
    enable = true;

    settings = {
      # previously hard-coded secret key. The grafana setup doesn't have any secret data in it,
      # so this is probably fine.
      security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "${config.networking.hostName}.tail51d48.ts.net";
        root_url = "https://${config.networking.hostName}.tail51d48.ts.net";
      };
    };
    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };
}
