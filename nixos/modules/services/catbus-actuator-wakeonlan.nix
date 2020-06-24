{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-actuator-wakeonlan;

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    mqttBroker = "tcp://${cfg.mqttBroker.host}:${toString cfg.mqttBroker.port}";
    devices = cfg.devices;
  });

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

    devices = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
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
      });
      example = { TV = { mac = "aa:bb:cc:dd:ee:ff"; topic = "home/living-room/tv/power"; }; };
      description = "A set of devices and their MACs & controller topics.";
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

