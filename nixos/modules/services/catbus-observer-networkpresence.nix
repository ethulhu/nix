{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-observer-networkpresence;

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

  options.eth.services.catbus-observer-networkpresence = {

    enable = mkEnableOption "Whether to enable the Catbus network-presence observer";

    interface = mkOption {
      type = types.str;
      description = "interface to scan";
      default = "";
      example = "enp2s0";
    };

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
    assertions = [
      {
        assertion = cfg.interface != "";
        message = "must set config.eth.services.catbus-observer-networkpresence.interface";
      }
    ];

    systemd.services.catbus-observer-networkpresence = {
      enable = true;
      description = "Detect devices on the network to publish to Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN";

        ExecStart = "${pkgs.eth.catbus-networkpresence}/bin/catbus-observer-networkpresence --config-path ${configJSON} --interface ${cfg.interface}";

        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictNamespaces = true;
      };
    };
  };

}

