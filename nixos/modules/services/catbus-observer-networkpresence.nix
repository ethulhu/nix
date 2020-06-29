{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-observer-networkpresence;

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    mqttBroker = cfg.mqttBroker;
    devices = cfg.devices;
  });

in {

  options.eth.services.catbus-observer-networkpresence = {

    enable = mkEnableOption "Whether to enable the Catbus network-presence observer";

    interface = mkOption {
      type = types.str;
      description = "interface to scan";
      default = "";
      example = "enp2s0";
    };

    mqttBroker = mkOption {
      type = types.str;
      description = "URL of the MQTT broker.";
      example = "tcp://broker.local:1883";
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

