{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.sites.go;

  mkLocation = virtualHost: module: url: {
    name = "/${module}";
    value = {
      extraConfig = ''
        if ($args = "go-get=1") {
          add_header Content-Type text/html;
          return 200 '<meta name="go-import" content="${virtualHost}/${module} git ${url}">';
        }
        return 302 ${url};
      '';
    };
  };

in {
  options.eth.sites.go = {
    enable = mkEnableOption "Whether to enable the Go site.";

    https = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable HTTPS.";
    };

    virtualHost = mkOption {
      type = types.str;
      default = "_";
      description = "Virtual Host to install the site under in Nginx.";
      example = "go.eth.moe";
    };

    modules = mkOption {
      type = types.attrsOf types.str;
      description = "A set of modules and their underlying git repos.";
      example = { catbus = "https://git.eth.moe/go-catbus"; };
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts.${cfg.virtualHost} = {
      forceSSL = cfg.https;
      enableACME = cfg.https;

      locations = listToAttrs (mapAttrsToList (mkLocation cfg.virtualHost) cfg.modules);
    };
  };
}
