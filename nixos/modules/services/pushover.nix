{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.pushover;

  escapeName = name: "pushover-${replaceStrings [ " " "'" ] [ "-" "" ] name}";

  mkService = name: opts: {
    name = escapeName name;
    value = {
      description = "Send ${name} notification";
      serviceConfig = {
        DynamicUser = true;
        ExecStart = pkgs.writeShellScript (escapeName name) ''
          ${pkgs.curl}/bin/curl \
            --verbose \
            --form-string user=${cfg.userKey} \
            --form-string token=${cfg.apiKey} \
            --form-string message=${escapeShellArg opts.message} \
            https://api.pushover.net/1/messages.json
        '';
        Environment = [ "HOME=/tmp" ];
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
      description = "Periodically send ${name} notification";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "${escapeName name}.service";
        OnCalendar = opts.schedule;
        RandomizedDelaySec = opts.delayUpTo;
        Persistent = true;
      };
    };
  };

in {
  options.eth.services.pushover = {
    enable = mkEnableOption "Send reminders with Pushover";

    userKey = mkOption {
      type = types.str;
      description = "Your user key (NB: this will go into the Nix store)";
    };
    apiKey = mkOption {
      type = types.str;
      description = "The application API key (NB: this will go into the Nix store)";
    };

    reminders = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkEnableOption "Send a reminder with Pushover";

          message = mkOption {
            type = types.str;
            description = "The message to send.";
          };

          schedule = mkOption {
            type = types.str;
            description = "A systemd.time timespec.";
          };
          delayUpTo = mkOption {
            type = types.str;
            description = "A systemd.time duration.";
          };
        };
      });
      example = {
        "eat dinner" = {
          enable = true;
          message = "food is good for you";
          schedule = "daily 18:30";
          delayUpTo = "1h";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services = mapAttrs' mkService cfg.reminders;
      timers = mapAttrs' mkTimer cfg.reminders;
    };
  };
}
