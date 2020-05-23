{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.services.helix-player;
  helixPackage = pkgs.eth.helix;

  runtimeDirectory = "helix-player";
  socket = "/run/${runtimeDirectory}/listen.sock";

in {

  options.services.helix-player = {

    enable = mkEnableOption "Whether to enable helix-player";

    socket = mkOption {
      type = types.str;
      readOnly = true;
      description = "Path of the UNIX socket to listen on.";
      example = socket;
    };
  };


  config = mkIf cfg.enable {

    services.helix-player.socket = socket;

    environment.systemPackages = [
      helixPackage
    ];

    systemd.services.helix-player = {
      enable = true;
      description = "Helix UPnP player & controller";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = "yes";
        Group = config.services.nginx.group;
        RuntimeDirectory = "${runtimeDirectory}";
        ExecStart = "${helixPackage}/bin/helix-player -socket ${socket}";
      };
    };
  };

}
