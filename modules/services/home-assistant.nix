{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  networking.firewall.allowedTCPPorts = [8123];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "esphome"
      "hue"
      "met"
      "radio_browser"
      "shelly"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };
}
