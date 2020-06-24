{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.ambience;

  mkService = name: opts: {
    name = "ambience-${name}";
    value = {
      enable = opts.enable;
      description = "Play ambient ${name} on loop";
      wants = [ "sound.target" ];
      after = [ "sound.target" ];
      wantedBy = [ "multi-user.target" ];
      partOf = [ "snapserver.service" ];
      serviceConfig = {
        DynamicUser = true;
        Group = "audio";

        ExecStart = "${pkgs.mpv}/bin/mpv --audio-display=no --audio-channels=stereo --audio-samplerate=48000 --audio-format=s16 --ao=pcm --ao-pcm-file=${opts.pipe} --loop=inf ${opts.file}";
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "";
        RestrictNamespaces = true;
      };
    };
  };

in {
  options.eth.services.ambience = {
    enable = mkEnableOption "Play ambient sounds.";

    streams = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkEnableOption "Play ambient sounds.";

          file = mkOption {
            type = types.str;
            description = "file to play on loop";
            default = "";
            example = "/var/lib/ambience/rain.m4a";
          };

          pipe = mkOption {
            type = types.str;
            description = "pipe to play into";
            default = "";
            example = "/run/snapserver/rain";
          };
        };
      });
      default = {};
      # example = { rain = { enable = true; file = "/var/lib/ambience/rain.mp3"; pipe = "/run/snapserver/rain"; }; };
      description = "Streams to pipe to Snapserver";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.snapserver.enable;
        message = "must enable Snapserver to enable Ambience";
      }
    ];
    systemd.services = listToAttrs (mapAttrsToList mkService cfg.streams);
  };
}
