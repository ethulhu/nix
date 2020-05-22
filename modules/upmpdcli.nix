{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.upmpdcli;

  cacheDir = "upmpdcli";

  upmpdConf = pkgs.writeText "upmpd.conf" ''
    cachedir = /var/cache/${cacheDir}
 
    friendlyname = ${cfg.friendlyName}

    mpdhost = ${cfg.mpd.host}
    mpdport = ${toString cfg.mpd.port}

    ${optionalString (cfg.mpd.password != "") "${cfg.mpd.password}"}

    ${cfg.extraConfig}
  '';

in {
  options.services.upmpdcli = {
    enable = mkEnableOption "Run upmpdcli server";

    friendlyName = mkOption {
      type = types.str;
      default = "UpMpd";
      description = "Friendly Name used for UPnP discovery.";
    };

    mpd = {
      host = mkOption {
        type = types.str;
        default = config.services.mpd.network.listenAddress;
        description = "Host of the MPD server.";
      };
      port = mkOption {
        type = types.int;
        default = config.services.mpd.network.port;
        description = "Port of the MPD server.";
      };
      password = mkOption {
        type = types.str;
        default = "";
        description = "Password of the MPD server.";
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.eth.upmpdcli
    ];

    systemd.services.upmpdcli = {
      enable = true;
      description = "";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.openssl pkgs.python3 ];
      serviceConfig = {
        DynamicUser = "yes";
        CacheDirectory = cacheDir;
        Type = "simple";
        ExecStart="${pkgs.eth.upmpdcli}/bin/upmpdcli -c ${upmpdConf}";
        Restart = "always";
        RestartSec = "1min";
      };
    };
  };
}
