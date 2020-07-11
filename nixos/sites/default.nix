{ pkgs, ... }:

{
  https = site: site // {
    forceSSL = true;
    enableACME = true;
  };

  catbus-web-ui = pkgs.callPackage ./catbus-web-ui.nix {};
}
