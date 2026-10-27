_: {
  services.thelounge = {
    enable = true;
    extraConfig = {
      host = "127.0.0.1";
      reverseProxy = true;
    };
  };

  systemd.services.thelounge.serviceConfig.User = "thelounge";
}
