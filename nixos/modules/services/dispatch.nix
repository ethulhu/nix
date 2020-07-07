{ config, lib, pkgs, ... }:
with lib;

let

  cfg = config.eth.services.dispatch;

  systemdDirectoryName = "dispatch";
  runtimeDirectory = "/run/${systemdDirectoryName}";
  socket = "${runtimeDirectory}/listen.sock";

  configJSON = pkgs.writeText "config.json" (builtins.toJSON {
    rules = cfg.rules;
  });

in {

  options.eth.services.dispatch = {
    enable = mkEnableOption "Whether to enable dispatch";

    socket = mkOption {
      type = types.path;
      readOnly = true;
      description = "Path of the UNIX socket to listen on.";
      default = socket;
    };

    rules = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          triggers = mkOption {
            type = types.listOf (types.submodule {
              options = {
                url = mkOption {
                  type = types.str;
                  example = "/gitolite-repo-updated";
                };
                formValues = mkOption {
                  type = types.attrsOf types.str;
                  example = {
                    repo = "catbus-web-ui";
                  };
                  default = {};
                };
              };
            });
            default = [];
          };
          actions = mkOption {
            type = types.listOf (types.submodule {
              options = {
                url = mkOption {
                  type = types.str;
                  example = "https://build.eth.moe/deploy";
                };
                formValues = mkOption {
                  type = types.attrsOf types.str;
                  example = {
                    project = "catbus-web-ui";
                  };
                  default = {};
                };
              };
            });
            default = [];
          };
        };
      });
      example = {
        "update Catbus UI" = {
          triggers = [
            { url = "/gitolite-repo-updated"; formValues = { repo = "catbus-web-ui"; }; }
          ];
          output = [
            { url = "https://build.eth.moe/deploy"; formValues = { project = "catbus-web-ui"; }; }
          ];
        };
      };
      default = {};
    };
  };


  config = mkIf cfg.enable {
    systemd.services.dispatch = {
      enable = true;
      description = "Webhook & MQTT dispatch server";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Group = config.services.nginx.group;

        RuntimeDirectory = systemdDirectoryName;

        ExecStart = "${pkgs.eth.dispatch}/bin/dispatch -config-path ${configJSON} -listen ${socket}";

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
      };
    };
  };

}
