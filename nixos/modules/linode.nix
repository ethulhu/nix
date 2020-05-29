{ config, pkgs, lib, ... }:
with lib;

# from https://www.linode.com/docs/tools-reference/custom-kernels-distros/install-nixos-on-linode/.

let 
  cfg = config.eth.linode;

in {

  options.eth.linode = {
    enable = mkEnableOption "good defaults for Linodes";
  };

  config = mkIf cfg.enable {

    # Enable LISH serial console.
    boot.kernelParams = [ "console=ttyS0,19200n8" ];
    boot.loader.grub.extraConfig = ''
      serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial;
    '';

    # GRUB has issues with Linode,
    # so this ignores the warnings.
    boot.loader.grub.forceInstall = true;
  
    # A long timeout to cope with LISH delays.
    boot.loader.timeout = 10;
  
    boot.loader.grub = {
      enable = true;
      version = 2;
      device = "nodev";  # "nodev" for EFI.
    };
  };
}
