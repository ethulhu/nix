{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.helix-directory-jackalope;

in {

  options.eth.services.helix-directory-jackalope = {

    enable = mkEnableOption "Whether to enable helix-directory-jackalope";

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

    jackalopePath = mkOption {
      type = types.str;
      default = "";
      description = "Path to Jackalope DB";
      example = "/mnt/md0/media/jackalope.db";
    };
  };


  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.directory != "";
        message = "must set config.eth.services.helix-directory-jackalope.directory";
      }
      {
        assertion = cfg.jackalopePath != "";
        message = "must set config.eth.services.helix-directory-jackalope.jackalopePath";
      }
    ];

    systemd.services.helix-directory-jackalope = {
      enable = true;
      description = "Helix UPnP ContentDirectory server, with Jackalope";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ffmpeg ];
      serviceConfig = {
        DynamicUser = true;

        ExecStart = "${pkgs.eth.helix}/bin/helix-directory-jackalope -friendly-name ${escapeShellArg cfg.friendlyName} -path ${escapeShellArg cfg.directory} -jackalope-path ${escapeShellArg cfg.jackalopePath}";

        Restart = "always";
        RestartSec = "1min";

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
      };
    };
  };

}
