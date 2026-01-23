# Networking config when running nixos (not dwarwin)
{...}: {
  networking = {
    extraHosts = ''
      127.0.0.1 localstack
    '';
    firewall.checkReversePath = false;
    networkmanager.enable = true;
  };
  services.tailscale.enable = true;
}
