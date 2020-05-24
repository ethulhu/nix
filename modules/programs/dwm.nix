{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.programs.dwm;

in {
  options.eth.programs.dwm = {
    enable = mkEnableOption "Whether to enable dwm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.eth.dwm ];
    services.xserver.windowManager.session = singleton {
      name = "dwm";
      start = ''
        ${pkgs.eth.dwm}/bin/dwm &
        waitPID=$!
      '';
    };
  };
}
