{ pkgs, ... }:

{
  catbus-web-ui = pkgs.callPackage ./catbus-web-ui.nix {};

  https = site: site // {
    forceSSL = true;
    enableACME = true;
  };

  static = root: {
    locations = {
      "/" = {
        root = root;
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
