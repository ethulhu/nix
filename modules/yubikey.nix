{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.yubikey;

in {

  options.eth.yubikey = {
    enable = mkEnableOption "Set up Yubikey";
  };

  config = mkIf cfg.enable {

    hardware.u2f.enable = true;

    programs.ssh.startAgent = false;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };

    services.pcscd.enable = true;

    services.udev.packages = with pkgs; [
      libu2f-host
      yubikey-personalization
    ];

    environment.systemPackages = with pkgs; [
      gnupg
      pinentry-curses
    ];

    environment.shellInit = ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
    programs.fish.shellInit = ''
      gpg-connect-agent /bye
      set -Ux SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    '';

  };
}
