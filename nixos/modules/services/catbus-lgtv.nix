{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.catbus-lgtv;

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    mqttBroker = cfg.mqttBroker;
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

  options.eth.services.catbus-lgtv = {

    enable = mkEnableOption "Whether to enable the Catbus WebOS LGTV daemons.";

    mqttBroker = mkOption {
      type = types.str;
      description = "URL of the MQTT broker.";
      example = "tcp://broker.local:1883";
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
        description = "MQTT topic for controlling the TV's app";
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
    systemd.services.catbus-lgtv-actuator = {
      enable = true;
      description = "Control a WebOS LGTV via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-lgtv}/bin/catbus-lgtv-actuator --config-path ${configJSON}";

        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
      };
    };

    systemd.services.catbus-lgtv-observer = {
      enable = true;
      description = "Observe a WebOS LGTV via Catbus";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.catbus-lgtv}/bin/catbus-lgtv-observer --config-path ${configJSON}";

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

