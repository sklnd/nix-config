{pkgs, ...}: let
  garageDoor = number: reed: relay: let
    id = "garage_door_${toString number}";
    pulse = reedState: [
      {
        condition = "state";
        entity_id = reed;
        state = reedState;
      }
      {
        condition = "state";
        entity_id = relay;
        state = "off";
      }
      {
        action = "switch.turn_on";
        target.entity_id = relay;
      }
    ];
  in {
    name = "Garage Door ${toString number}";
    unique_id = id;
    device_class = "garage";
    availability = "{{ has_value('${reed}') and has_value('${relay}') }}";
    # shortcut: the closed sensor can't detect movement; add position feedback for that.
    state = "{{ 'closed' if is_state('${reed}', 'off') else 'open' }}";
    open_cover = pulse "off";
    close_cover = pulse "on";
  };
in {
  environment.systemPackages = with pkgs; [
    home-manager
  ];

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
      "radio_browser"
      "shelly"
      "shopping_list"
      "sonos"
      "unifi"
      "weatherflow"
      "weatherflow_cloud"
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
        ical
      ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      template = [
        {
          cover = [
            # Add Door 1 here once it has a shelly installed
            (garageDoor 2 "binary_sensor.garage_garage_door_2_input_100" "switch.garage_garage_door_2")
          ];
        }
      ];
    };
  };
}
