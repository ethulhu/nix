{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-observer-lgtv;

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    mqttBroker = "tcp://${cfg.mqttBroker.host}:${toString cfg.mqttBroker.port}";
    apps = cfg.apps;
    topics = {
      app = cfg.topics.input;
      appValues = cfg.topics.inputValues;
      power = cfg.topics.power;
      volume = cfg.topics.volume;
    };
    tv = cfg.tv;
  });

in {

  options.eth.services.catbus-observer-lgtv = {

    enable = mkEnableOption "Whether to enable the Catbus WebOS LGTV observer";

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

    tv = {
      host = mkOption {
        type = types.str;
        default = "";
        description = "TV host";
        example = "192.168.16.69";
      };
      key = mkOption {
        type = types.str;
        default = "";
        description = "A key generated from pkgs.eth.catbus-lgtv/bin/generate-key";
        example = "25561897424495c18042fef5ebe8d7fc";
      };
    };

    topics = {
      input = mkOption {
        type = types.str;
        description = "MQTT topic for controlling the TV's input";
        example = "home/living-room/tv/app_enum";
      };
      inputValues = mkOption {
        type = types.str;
        description = "MQTT topic for exporting the TV's apps";
        example = "home/living-room/tv/app_enum/values";
      };
      power = mkOption {
        type = types.str;
        description = "MQTT topic for controlling the TV's power";
        example = "home/living-room/tv/power";
      };
      volume = mkOption {
        type = types.str;
        description = "MQTT topic for controlling the TV's volume";
        example = "home/living-room/tv/volume_percent";
      };
    };

    apps = mkOption {
      type = types.attrsOf types.str;
      example = { PS4 = "com.webos.input.hdmi1"; };
      description = "A set of friendly app names and their corresponding IDs";
    };
  };


  config = mkIf cfg.enable {
    systemd.services.catbus-observer-lgtv = {
      enable = true;
      description = "Observe a WebOS LGTV via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-lgtv}/bin/catbus-observer-lgtv --config-path ${configJSON}";

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

