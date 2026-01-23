{ ... }:
{
  services.thelounge = {
    enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 9000 ];

  systemd.services.thelounge.serviceConfig.User = "thelounge";
}
