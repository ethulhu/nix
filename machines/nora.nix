# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  ethNixLocal = import /home/eth/src/nix;
  ethNixRemote = import ( builtins.fetchGit { url = "https://github.com/ethulhu/nix"; } );

  ethNix = ethNixLocal;

in {
  imports = [
    ./hardware-configuration.nix
    ethNix.modules
  ];

  eth.nix = {
    overlays = {
      eth = true;
    };
    gc = {
      enable = true;
      schedule = "weekly";
      olderThan = "30d";
    };
  };

  eth.linode.enable = true;

  networking = {
    hostName = "nora";

    enableIPv6 = true;

    interfaces = {
      enp0s4 = {
        useDHCP = true;
      };
    };

    # The global useDHCP flag is deprecated, so is explicitly set to false.
    useDHCP = false;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget

    # Linode.
    # inetutils
    mtr
    sysstat
  ];

  environment.shellAliases = {
    l = "ls -1";
    ll = "ls -lash";
  };

  eth.users.eth = {
    enable = true;
  };

  eth.location = "London";

  programs.mosh.enable = true;
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    enable = true;
  };
  programs.vim.defaultEditor = true;

  eth.services.ssh = {
    enable = true;
    sshAgentAuth = true;
  };

  services.tailscale.enable = true;

  security.acme.acceptTerms = true;
  security.acme.email = "acme-letsencrypt@ethulhu.co.uk";


  services.nginx = {
    enable = true;
    virtualHosts = {
      "static.eth.moe" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = /var/www/static.eth.moe;
        };
      };
    };
  };
  eth.sites.go = {
    enable = true;
    virtualHost = "go.eth.moe";
    modules = {
      catbus = "https://git.eth.moe/go-catbus";
      flag = "https://github.com/ethulhu/go-flag";
      jackalope = "https://git.sr.ht/~eth/jackalope";
      logger = "https://github.com/ethulhu/go-logger";
    };
  };
  eth.sites.cgit = {
    enable = true;
    virtualHost = "git.eth.moe";
    scanPath = "${config.services.gitolite.dataDir}/repositories/";
    projectList = "${config.services.gitolite.dataDir}/projects.list";
  };
  eth.sites.recipes = {
    enable = true;
    virtualHost = "recipes.eth.moe";
  };

  services.gitolite = {
    enable = true;
    adminPubkey = builtins.elemAt config.users.users.eth.openssh.authorizedKeys.keys 0;
    user = "git";
    group = "git";
    extraGitoliteRc = ''
      $RC{GIT_CONFIG_KEYS} = '.*';
      push( @{$RC{ENABLE}}, 'symbolic-ref' );
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

}

