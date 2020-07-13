{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.dlnatoad;

  systemdDirectoryName = "dlnatoad";
  cacheDirectory = "/var/cache/${systemdDirectoryName}";

in {

  options.eth.services.dlnatoad = {
    enable = mkEnableOption "Whether to enable DLNAtoad";

    interface = mkOption {
      type = types.str;
      default = "";
      description = "Hostname or IP address of interface to bind to.";
    };

    directories = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of paths to index & serve.";
      example = [ "/mnt/md0/media" ];
    };
  };


  config = mkIf cfg.enable {
    systemd.services.dlnatoad = {
      enable = true;
      description = "DLNAtoad UPnP ContentDirectory service";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ffmpeg ];
      serviceConfig = {
        DynamicUser = true;

        CacheDirectory = systemdDirectoryName;

        ExecStart = ''
          ${pkgs.eth.dlnatoad}/bin/dlnatoad \
            ${concatStringsSep " " cfg.directories} \
            --db ${cacheDirectory}/db \
            --thumbs ${cacheDirectory} \
            ${if cfg.interface != "" then "--interface ${cfg.interface}" else ""} \
            --verbose
        '';

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
      };
    };
  };

}

