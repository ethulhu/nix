{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-lifx;

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    mqttBroker = cfg.mqttBroker;
    bulbs = cfg.bulbs;
  });

in {

  options.eth.services.catbus-lifx = {

    enable = mkEnableOption "Whether to enable the Catbus Lifx bulb daemons.";

    mqttBroker = mkOption {
      type = types.str;
      description = "URL of the MQTT broker.";
      example = "tcp://broker.local:1883";
    };

    bulbs = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          topics = {
            power = mkOption {
              type = types.str;
              description = "MQTT topic for controlling the bulb's power";
              example = "home/living-room/light/power";
            };
            hue = mkOption {
              type = types.str;
              description = "MQTT topic for controlling the bulb's hue";
              example = "home/living-room/light/hue_degrees";
            };
            saturation = mkOption {
              type = types.str;
              description = "MQTT topic for controlling the bulb's saturation";
              example = "home/living-room/light/saturation_percent";
            };
            brightness = mkOption {
              type = types.str;
              description = "MQTT topic for controlling the bulb's brightness";
              example = "home/living-room/light/brightness_percent";
            };
            kelvin = mkOption {
              type = types.str;
              description = "MQTT topic for controlling the bulb's kelvin";
              example = "home/living-room/light/kelvin";
            };
          };
        };
      });
      example = { Bedroom = { topics = { power = "home/living-room/light/power"; }; }; };
      description = "A set of devices and their MACs & controller topics.";
    };
  };


  config = mkIf cfg.enable {
    systemd.services.catbus-lifx-actuator = {
      enable = true;
      description = "Control Lifx bulbs via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-lifx}/bin/catbus-lifx-actuator --config-path ${configJSON}";

        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
      };
    };

    systemd.services.catbus-lifx-observer = {
      enable = true;
      description = "Observe Lifx bulbs via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-lifx}/bin/catbus-lifx-observer --config-path ${configJSON}";

        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
      };
    };
  };

}

