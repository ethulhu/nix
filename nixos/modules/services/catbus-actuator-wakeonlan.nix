{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-actuator-wakeonlan;

  configJSON = pkgs.writeText "config.json" ''
      {
        "mqttBroker": "tcp://${cfg.mqttBroker.host}:${toString cfg.mqttBroker.port}",

        "devices": {
          "TV": {
            "mac": "${cfg.devices.tv.mac}",
            "topic": "${cfg.devices.tv.topic}"
          }
        }
      }
  '';

in {

  options.eth.services.catbus-actuator-wakeonlan = {

    enable = mkEnableOption "Whether to enable the Catbus Wake-On-LAN actuator";

    mqttBroker = {
      host = mkOption {
        type = types.str;
        description = "Host of the MQTT broker.";
        example = "localhost";
      };
      port = mkOption {
        type = types.int;
        description = "Port of the MQTT broker.";
        default = 1883;
      };
    };

    # TODO: replace this with a proper set of option sets.
    devices = {
      tv = {
        mac = mkOption {
          type = types.str;
          description = "The device's MAC address";
          example = "aa:bb:cc:dd:ee:ff";
        };
        topic = mkOption {
          type = types.str;
          description = "MQTT topic for controlling the device";
          example = "home/house/speakers/power";
        };
      };
    };
  };


  config = mkIf cfg.enable {
    systemd.services.catbus-actuator-wakeonlan = {
      enable = true;
      description = "Power devices on using Wake-On-LAN via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-wakeonlan}/bin/catbus-actuator-wakeonlan --config-path ${configJSON}";

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

