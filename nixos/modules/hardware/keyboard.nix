{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.hardware.keyboard;

in {

  options.eth.hardware.keyboard = {
    enableColemak = mkEnableOption "Eth's keyboard preferences";
  };

  config = mkIf cfg.enableColemak {

    console.useXkbConfig = true;

    services.xserver = {
      layout = "us";
      xkbVariant = "colemak";
      xkbOptions = "caps:escape";
    };

  };
}
