# https://nixos.wiki/wiki/Steam.

{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.programs.steam;

in {
  options.eth.programs.steam = {
    enable = mkEnableOption "Whether to enable Steam and supports";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam
      steam-run-native
    ];

    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.pulseaudio.support32Bit = true;
  };
}
