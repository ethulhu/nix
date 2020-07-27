{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.mosquitto;

  systemdDirectoryName = "mosquitto";
  stateDirectory = "/var/lib/${systemdDirectoryName}";
  runtimeDirectory = "/run/${systemdDirectoryName}";

  mosquittoConf = pkgs.writeText "mosquitto.conf" ''
    ${optionalString cfg.mqtt.enable ''
      listener ${toString cfg.mqtt.port} ${optionalString (cfg.mqtt.host != "") cfg.mqtt.host}
    ''}

    ${optionalString cfg.websockets.enable ''
      listener ${toString cfg.websockets.port} ${optionalString (cfg.websockets.host != "") cfg.websockets.host}
      protocol websockets
    ''}

    ${optionalString cfg.persistence ''
      persistence true
      persistence_location ${stateDirectory}/
    ''}

    ${cfg.extraConfig}
  '';

in {

  options.eth.services.mosquitto = {

    enable = mkEnableOption "Whether to enable mosquitto.";

    persistence = mkOption {
      type = types.bool;
      default = true;
    };

    mqtt = {
      enable = mkEnableOption "Whether to listen on unencrypted MQTT.";
      host = mkOption {
        type = types.str;
        default = "";
        example = "10.11.12.14";
      };
      port = mkOption {
        type = types.int;
        default = 1883;
      };
    };

    websockets = {
      enable = mkEnableOption "Whether to listen on unencrypted Websockets.";
      host = mkOption {
        type = types.str;
        default = "";
        example = "10.11.12.14";
      };
      port = mkOption {
        type = types.int;
        default = 1884;
      };
    };

    extraConfig = mkOption {
      type = types.str;
      description = "Config to append to the generated config.";
      example = ''
        log_type all
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.services.mosquitto = {
      enable = true;
      description = "Mosquitto MQTT broker";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = systemdDirectoryName;
        StateDirectory = systemdDirectoryName;
        ExecStart = "${pkgs.mosquitto}/bin/mosquitto -c ${mosquittoConf}";
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
        RestrictNamespaces = true;
      };
    };
  };
}
