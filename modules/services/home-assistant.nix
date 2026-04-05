{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  networking.firewall.allowedTCPPorts = [8123];

  # Needed for python-xbox.
  # This is marked insecure for timing attack reasons, which isn't relevant for HA on a private network.
  # https://github.com/tlsfuzzer/python-ecdsa/issues/330
  nixpkgs.config.permittedInsecurePackages = [
    "python3.13-ecdsa-0.19.1"
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "analytics"
      "aranet"
      "esphome"
      "hue"
      "isal"
      "met"
      "shelly"
      "shopping_list"
      "sonos"
      "unifi"
      "weatherflow"
    ];
    extraPackages = python3Packages:
      with python3Packages; [
        androidtvremote2
        gtts
        pyatv
        pychromecast
        python-otbr-api
        python-xbox
        soco
        uiprotect
        unifi-discovery
        xboxapi
      ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };
}
