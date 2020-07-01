{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.helix-player;

  systemdDirectoryName = "helix-player";
  runtimeDirectory = "/run/${systemdDirectoryName}";
  socket = "${runtimeDirectory}/listen.sock";

in {

  options.eth.services.helix-player = {

    enable = mkEnableOption "Whether to enable helix-player";

    socket = mkOption {
      type = types.path;
      readOnly = true;
      description = "Path of the UNIX socket to listen on.";
      default = socket;
    };
  };


  config = mkIf cfg.enable {
    systemd.services.helix-player = {
      enable = true;
      description = "Helix UPnP player & controller";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Group = config.services.nginx.group;

        RuntimeDirectory = systemdDirectoryName;

        ExecStart = "${pkgs.eth.helix}/bin/helix-player -socket ${socket}";

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
      };
    };
  };

}
