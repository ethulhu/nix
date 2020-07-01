{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.nix;

  mozilla = import (builtins.fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");

  eth = import ../../pkgs;

in {
  options.eth.nix = {
    allowUnfree = mkOption {
      type = types.bool;
      description = "Allow non-free software.";
      default = false;
    };

    gc = {
      enable = mkEnableOption "Enable the garbage collector.";
      schedule = mkOption {
        type = types.str;
        default = config.nix.gc.dates;
        description = "A systemd.time(7) timespec";
      };
      olderThan = mkOption {
        type = types.str;
        default = "30d";
        description = "Garbage-collect NixOS configurations older than this.";
      };
    };

    overlays = {
      eth     = mkEnableOption "Eth (yours truly)";
      mozilla = mkEnableOption "Mozilla (Rust, Firefox, etc)";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = cfg.allowUnfree;

    nix.gc = {
      automatic = cfg.gc.enable;
      dates = cfg.gc.schedule;
      options = "--delete-older-than ${cfg.gc.olderThan}";
    };

    nixpkgs.overlays = builtins.concatLists [
      ( if cfg.overlays.eth     then [ eth     ] else [] )
      ( if cfg.overlays.mozilla then [ mozilla ] else [] )
    ];
  };
}
