{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.overlays;

  mozilla = import (builtins.fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");

  eth = import ../pkgs;

in {
  options.eth.overlays = {
    eth     = mkEnableOption "Eth (yours truly)";
    mozilla = mkEnableOption "Mozilla (Rust, Firefox, etc)";
  };

  config.nixpkgs.overlays = builtins.concatLists [
    ( if cfg.eth     then [ eth     ] else [] )
    ( if cfg.mozilla then [ mozilla ] else [] )
  ];
}
