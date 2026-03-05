{pkgs, ...}: let
  dnsmasqConf = pkgs.writeText "dnsmasq.conf" ''
    # Listen only on localhost
    listen-address=127.0.0.1
    port=53

    # Local domain resolution
    # Send any host in *.local.honor to a local webserver
    address=/local.honor/127.0.0.1

    # Don't read /etc/resolv.conf or any other configuration files.
    no-resolv
    # Never forward plain names (without a dot or domain part)
    domain-needed
    # Never forward addresses in the non-routed address spaces.
    bogus-priv
  '';
in {
  environment.systemPackages = [pkgs.dnsmasq];

  launchd.daemons.dnsmasq = {
    command = "${pkgs.dnsmasq}/bin/dnsmasq --keep-in-foreground --conf-file=${dnsmasqConf}";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
