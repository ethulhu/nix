{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth;

  locations = {
    London = {
      latitude = 51.5074;
      longitude = 0.1278;
    };
  };

in {
  options.eth.location = mkOption {
    type = types.nullOr (types.enum (builtins.attrNames locations));
    default = null;
    description = "City name.";
  };

  config = mkIf (cfg.location != null) {
    location = locations.${cfg.location};
  };
}
