{ pkgs, ... }:

{
  catbus-web-ui = pkgs.callPackage ./catbus-web-ui.nix {};
  cgit          = pkgs.callPackage ./cgit.nix {};
  go-packages   = pkgs.callPackage ./go-packages.nix {};

  https = {
    forceSSL = true;
    enableACME = true;
  };

  static = root: {
    locations = {
      "/" = {
        root = root;
        extraConfig = ''
          if ($request_uri ~ ^/(.*)\.html$) {
            return 302 /$1;
          }
          if ($request_uri ~ ^/(.*)/$) {
            return 302 /$1;
          }
          try_files $uri $uri.$extension $uri/ =404;
        '';
      };
    };
  };

  proxyACME = remoteHost: {
    locations = {
      "/.well-known/acme-challenge/" = {
        proxyPass = "http://${remoteHost}";
      };
    };
  };

  proxySocket = socketPath: {
    locations = {
      "/" = {
        proxyPass = "http://unix:/${socketPath}";
      };
    };
  };
}
