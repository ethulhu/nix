{ pkgs, lib }:

{ fcgiwrapSocket
, scanPath
, projectList

, aboutFilter ? "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh"
, sourceFilter ? "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py"

, extraConfig ? ""
}:

let
  cgitConfig = pkgs.writeText "cgitrc" ''
    cache-size=1000
    virtual-root=/

    about-filter=${aboutFilter}
    source-filter=${sourceFilter}

    remove-suffix=1

    enable-git-config=1
    #enable-gitweb-owner=1
    project-list=${projectList}
    scan-path=${scanPath}

    enable-blame=1
    enable-follow-links=1
    enable-index-owner=0

    enable-http-clone=1

    snapshots=tar.gz zip

    ${extraConfig}
  '';

in {
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

      fastcgi_pass unix:${fcgiwrapSocket};
    }
  '';
}
