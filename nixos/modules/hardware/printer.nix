{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.hardware.printer;

in {

  options.eth.hardware.printer = {
    enable = mkEnableOption "Whether to enable Eth's home printer";
  };

  config = mkIf cfg.enable {
    # Avahi is needed for dnssd (mDNS / Bonjour) printers.
    services.avahi = {
      enable = true;
      nssmdns = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [ brlaser ];
    };

    hardware.printers.ensurePrinters = [
      {
        name = "Brother_HL-1210W";
        description = "Brother HL-1210W";
        deviceUri = "dnssd://Brother%20HL-1210W%20series._pdl-datastream._tcp.local/?uuid=e3248000-80ce-11db-8000-d89c67c1755c";
        model = "drv:///brlaser.drv/br1200.ppd";
      }
    ];
  };
}
