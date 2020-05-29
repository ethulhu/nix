{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-bridge-snapcast;

  configJSON = pkgs.writeText "config.json" ''
      {
        "broker_host": "${cfg.mqttBroker.host}",
        "broker_port": ${toString cfg.mqttBroker.port},

        "snapserver_host": "${cfg.snapserver.host}",
        "snapserver_port": ${toString cfg.snapserver.port},

        "topic_input": "${cfg.topics.input}",

        "snapcast_group_id": "${cfg.snapcastGroupID}"
      }
  '';

in {

  options.eth.services.catbus-bridge-snapcast = {

    enable = mkEnableOption "Whether to enable the Catbus Snapcast bridge";

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

    snapserver = {
      host = mkOption {
        type = types.str;
        description = "Host of the Snapserver.";
        example = "localhost";
      };
      port = mkOption {
        type = types.int;
        description = "Port of the Snapserver.";
        default = 1705;
      };
    };

    topics = {
      input = mkOption {
        type = types.str;
        description = "MQTT topic for controlling the Snapcast group input";
        example = "home/house/speakers/input_enum";
      };
    };

    snapcastGroupID = mkOption {
      type = types.str;
      description = "The ID of the Snapcast group to control";
      example = "352aba34-0ba8-8a4e-9f46-cb634b1c800a";
    };
  };


  config = mkIf cfg.enable {
    systemd.services.catbus-bridge-snapcast = {
      enable = true;
      description = "Control Snapcast via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-snapcast}/bin/catbus-bridge-snapcast --config-path ${configJSON}";

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

