{
  config,
  pkgs,
  lib,
  ...
}: {
  # Main Prometheus (federation endpoint)
  services.prometheus = {
    enable = true;
    port = 9090;

    scrapeConfigs = [
      # Federate from dev Prometheus
      {
        job_name = "federate-dev";
        honor_labels = true;
        metrics_path = "/federate";
        params = {
          "match[]" = [
            "{job=\"platform-api-dev\"}"
          ];
        };
        static_configs = [
          {
            targets = ["localhost:9091"];
          }
        ];
      }

      # Federate from prod Prometheus
      {
        job_name = "federate-prod";
        honor_labels = true;
        metrics_path = "/federate";
        params = {
          "match[]" = [
            "{job=\"platform-api-prod\"}"
          ];
        };
        static_configs = [
          {
            targets = ["localhost:9092"];
          }
        ];
      }
    ];
  };

  # Dev Prometheus instance
  systemd.services.prometheus-dev = {
    description = "Prometheus Dev Instance";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];

    serviceConfig = {
      Type = "simple";
      User = "prometheus";
      Group = "prometheus";
      ExecStart =
        "${pkgs.prometheus}/bin/prometheus "
        + "--config.file=/etc/prometheus/prometheus-dev.yml "
        + "--storage.tsdb.path=/var/lib/prometheus-dev/data "
        + "--web.listen-address=:9091 "
        + "--storage.tsdb.retention.time=15d";
      EnvironmentFile = "/etc/secrets/prometheus-dev-credentials";
      Restart = "always";
      StateDirectory = "prometheus-dev";
      StateDirectoryMode = "0750";
    };
  };

  # Prod Prometheus instance
  systemd.services.prometheus-prod = {
    description = "Prometheus Prod Instance";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];

    serviceConfig = {
      Type = "simple";
      User = "prometheus";
      Group = "prometheus";
      ExecStart =
        "${pkgs.prometheus}/bin/prometheus "
        + "--config.file=/etc/prometheus/prometheus-prod.yml "
        + "--storage.tsdb.path=/var/lib/prometheus-prod/data "
        + "--web.listen-address=:9092 "
        + "--storage.tsdb.retention.time=15d";
      EnvironmentFile = "/etc/secrets/prometheus-prod-credentials";
      Restart = "always";
      StateDirectory = "prometheus-prod";
      StateDirectoryMode = "0750";
    };
  };

  # Prometheus config
  environment.etc = {
    prometheus-dev = {
      source = ../../config/prometheus/prometheus-dev.yml;
      target = "prometheus/prometheus-dev.yml";
      mode = "0640";
      user = "prometheus";
      group = "prometheus";
    };
    prometheus-prod = {
      source = ../../config/prometheus/prometheus-prod.yml;
      target = "prometheus/prometheus-prod.yml";
      mode = "0640";
      user = "prometheus";
      group = "prometheus";
    };
  };

  # Ensure prometheus user and group exist
  users.users.prometheus = lib.mkIf (!config.services.prometheus.enable) {
    isSystemUser = true;
    group = "prometheus";
    home = "/var/lib/prometheus";
    createHome = true;
  };

  users.groups.prometheus = lib.mkIf (!config.services.prometheus.enable) {};

  # Tmpfiles rules for state directories
  systemd.tmpfiles.rules = [
    "d /var/lib/prometheus-dev 0750 prometheus prometheus -"
    "d /var/lib/prometheus-prod 0750 prometheus prometheus -"
    "d /etc/secrets 0700 root root -"
  ];
}
