{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.keyboard;

in {

  options.eth.keyboard = {
    enable = mkEnableOption "Eth's keyboard preferences";
  };

  config = mkIf cfg.enable {

    console.useXkbConfig = true;

    services.xserver = {
      layout = "us";
      xkbVariant = "colemak";
      xkbOptions = "caps:escape";
    };

  };
}
