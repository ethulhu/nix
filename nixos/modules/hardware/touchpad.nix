{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.hardware.touchpad;

in {
  options.eth.hardware.touchpad = {
    enable = mkEnableOption "Enable the touchpad.";

    naturalScrolling = mkOption {
      type = types.bool;
      description = "The good scrolling.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.libinput = {
      enable = true;
      naturalScrolling = cfg.naturalScrolling;
    };
  };
}
