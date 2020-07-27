{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.youtube-dl;

  escapeName = name: "youtube-dl-${replaceStrings [ " " "'" ] [ "-" "" ] name}";

  mkService = name: opts: {
    name = escapeName name;
    value = {
      description = "Download ${name}";
      serviceConfig = {
	User = cfg.user;
	Group = cfg.group;
        ExecStart = ''
          ${pkgs.youtube-dl}/bin/youtube-dl \
            --output ${escapeShellArg opts.directory}/${escapeShellArg opts.pattern} \
            --write-description \
            --write-info-json \
            --write-sub \
            --write-thumbnail \
            ${escapeShellArg opts.url}
        '';
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
      };
    };
  };

  mkTimer = name: opts: {
    name = escapeName name;
    value = {
      enable = opts.enable;
      description = "Periodically download ${name}";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Unit = "${escapeName name}.service";
        Persistent = true;
        RandomizedDelaySec = "8h";
      };
    };
  };

in {
  options.eth.services.youtube-dl = {
    enable = mkEnableOption "Download media with youtube-dl.";

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth";
    };
    group = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "users";
    };

    download = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkEnableOption "Enable downloader.";

          url = mkOption {
            type = types.str;
            description = "URL to download.";
            default = "";
            example = "http://web.server/rss.xml";
          };

          directory = mkOption {
            type = types.path;
            description = "Directory to download media to.";
            default = "";
            example = "/mnt/md0/media/podcasts";
          };

          pattern = mkOption {
            type = types.str;
            description = "Filename pattern";
            default = "";
            example = "%(title)s.%(ext)s";
          };
        };
      });
      default = {};
      example = {
        "Fun City" = {
          enable = true;
          url = "http://web.server/rss.xml";
          directory = "/mnt/md0/media/podcasts";
          pattern = "%(title)s.%(ext)s";
        };
      };
      description = "Things to download";
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services = mapAttrs' mkService cfg.download;
      timers = mapAttrs' mkTimer cfg.download;
    };
  };
}
