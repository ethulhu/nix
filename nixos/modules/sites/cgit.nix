{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.sites.cgit;
  fcgi = config.services.fcgiwrap;

  cgitConfig = pkgs.writeText "cgitrc" ''
    cache-size=1000
    virtual-root=/

    about-filter=${cfg.aboutFilter}
    source-filter=${cfg.sourceFilter}

    remove-suffix=1

    enable-git-config=1
    #enable-gitweb-owner=1
    project-list=${cfg.projectList}
    scan-path=${cfg.scanPath}

    enable-blame=1
    enable-follow-links=1
    enable-index-owner=0

    enable-http-clone=1

    snapshots=tar.gz zip

    ${cfg.extraConfig}
  '';

in {
  options.eth.sites.cgit = {
    enable = mkEnableOption "Whether to enable cgit.";

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

    aboutFilter = mkOption {
      type = types.path;
      default = "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
    };
    sourceFilter = mkOption {
      type = types.path;
      default = "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
    };

    scanPath = mkOption {
      type = types.path;
      description = "Path to search for Git repositories under.";
      example = "${config.services.gitolite.dataDir}/repositories/";
    };
    projectList = mkOption {
      type = types.path;
      description = "Path to a list of Git repositories to search for.";
      example = "${config.services.gitolite.dataDir}/projects.list";
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts.${cfg.virtualHost} = {
      forceSSL = cfg.https;
      enableACME = cfg.https;

      root = "${pkgs.cgit}/cgit/";
      extraConfig = ''
        try_files $uri @cgit;

        location @cgit {
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param CGIT_CONFIG     ${cgitConfig};
          fastcgi_param HTTP_HOST       $server_name;
          fastcgi_param PATH_INFO       $uri;
          fastcgi_param QUERY_STRING    $args;
          fastcgi_param SCRIPT_FILENAME ${pkgs.cgit}/cgit/cgit.cgi;

          fastcgi_pass unix:${fcgi.socketAddress};
        }
      '';
    };
 
    services.fcgiwrap = {
      enable = true;
    };
  };
}
