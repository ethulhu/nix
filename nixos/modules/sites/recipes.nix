{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.sites.recipes;

in {
  options.eth.sites.recipes = {
    enable = mkEnableOption "Whether to enable recipes.";

    https = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable HTTPS.";
    };

    virtualHost = mkOption {
      type = types.str;
      default = "_";
      description = "Virtual Host to install the site under in Nginx.";
      example = "git.eth.moe";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts.${cfg.virtualHost} = {
      forceSSL = cfg.https;
      enableACME = cfg.https;
      root = "${pkgs.eth.recipes}";
    };
  };
}
