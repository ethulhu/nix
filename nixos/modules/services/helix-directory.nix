{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.helix-directory;

in {

  options.eth.services.helix-directory = {

    enable = mkEnableOption "Whether to enable helix-directory";

    friendlyName = mkOption {
      type = types.str;
      default = "Helix (${config.networking.hostName})";
      description = "Human-readable name to broadcast";
      example = "My Media Server";
    };

    directory = mkOption {
      type = types.str;
      default = "";
      description = "Directory to serve";
      example = "/mnt/md0/media";
    };
  };


  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.directory != "";
        message = "must set config.eth.services.helix-directory.directory";
      }
    ];

    systemd.services.helix-directory = {
      enable = true;
      description = "Helix UPnP ContentDirectory server";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ffmpeg ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.helix}/bin/helix-directory -friendly-name ${escapeShellArg cfg.friendlyName} -path ${escapeShellArg cfg.directory}";

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
      };
    };
  };

}
