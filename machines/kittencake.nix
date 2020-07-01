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
    allowUnfree = true;
    gc = {
      enable = true;
      schedule = "weekly";
      olderThan = "30d";
    };
    overlays = {
      eth = true;
      mozilla = true;
    };
  };

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
      configurationLimit = 30;
    };
    initrd.luks.devices.root = {
      device = "/dev/disk/by-uuid/83d703db-51e0-422f-936e-9379bd7cdb80";
      preLVM = true;
      allowDiscards = true;
    };
    # tmpOnTmpfs = true;
  };

  networking = {
    hostName = "kittencake";

    wireless = {
      enable = true;
      userControlled.enable = true;
    };

    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;

    # The global flag is deprecated, so set to false.
    useDHCP = false;

    # useNetworkd = true;  # considered experimental and risky?
  };

  networking.firewall = {
    enable = true;
  };

  time.timeZone = "Europe/London";

  eth.location = "London";

  environment.systemPackages = with pkgs; [
    ag
    git
    tmux
    usbutils
    vim
    wget
  ];

  eth.hardware = {
    keyboard = {
      enableColemak = true;
    };
    touchpad = {
      enable = true;
      naturalScrolling = true;
    };
    yubikey = {
      enable = true;
    };
  };

  eth.users.eth = {
    enable = true;

    packages = {
      development = true;
      gui = true;
    };

    extraPackages = with pkgs; [
      mimic
      picotts
      speech-tools
      speechd
      # svox
    ];
  };

  # hardware.cpu.intel.updateMicrocode = true; ?

  services.thinkfan.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;
    displayManager = {
      lightdm = {
        enable = true;
        background = /home/eth/walls/lightdm.jpg;
      };
    };
  };

  programs.sway = {
    enable = true;
  };
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  eth.programs.steam = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

