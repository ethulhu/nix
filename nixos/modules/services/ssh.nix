{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.eth.services.ssh;

in {
  options.eth.services.ssh = {
    enable = mkEnableOption "Whether to enable SSHd with Eth's defaults.";

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to allow password authentication. Occasionally useful, used sparingly.";
    };

    sshAgentAuth = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable sudo authentication using ssh-agent.";
    };
  };

  config = mkIf cfg.enable {

    security.pam.enableSSHAgentAuth = cfg.sshAgentAuth;
    security.pam.services.sudo.sshAgentAuth = cfg.sshAgentAuth;

    services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = cfg.passwordAuthentication;
    };
  };
}
