{...}: {
  services.openssh = {
    enable = true;
    ports = [22];
    authorizedKeysInHomedir = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["chris"];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };
}
