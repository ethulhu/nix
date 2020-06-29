{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-snapcast;

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    mqttBroker = cfg.mqttBroker;
    topics = cfg.topics;
    snapcast = cfg.snapcast;
  });

in {

  options.eth.services.catbus-snapcast = {

    enable = mkEnableOption "Whether to enable the Catbus Snapcast bridge";

    mqttBroker = mkOption {
      type = types.str;
      description = "URL of the MQTT broker.";
      example = "tcp://broker.local:1883";
    };

    topics = {
      input = mkOption {
        type = types.str;
        description = "MQTT topic for controlling the Snapcast group input";
        example = "home/house/speakers/input_enum";
      };
    };

    snapcast = {
      groupId = mkOption {
        type = types.str;
        description = "The ID of the Snapcast group to control";
        example = "352aba34-0ba8-8a4e-9f46-cb634b1c800a";
      };
    };
  };


  config = mkIf cfg.enable {
    systemd.services.catbus-snapcast-actuator = {
      enable = true;
      description = "Control Snapcast via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-snapcast}/bin/catbus-snapcast-actuator --config-path ${configJSON}";

        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
      };
    };
    systemd.services.catbus-snapcast-observer = {
      enable = true;
      description = "Observe Snapcast for Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-snapcast}/bin/catbus-snapcast-observer --config-path ${configJSON}";

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

