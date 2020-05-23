{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.snapclient;

in {

  options.eth.services.snapclient = {

    enable = mkEnableOption "Whether to enable snapclient.";

    hostID = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "The name to give to the snapserver.";
      example = "Living Room";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.snapclient = {
      enable = true;
      description = "Snapcast client";
      wants = [ "network.target" "sound.target" ];
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = "yes";
        Group = "audio";
        ExecStart = "${pkgs.snapcast}/bin/snapclient --hostID ${escapeShellArg cfg.hostID}";
        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
        RestrictNamespaces = true;
      };
    };
  };
}
