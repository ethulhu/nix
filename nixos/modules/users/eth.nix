{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.users.eth;

  defaultPackages = with pkgs; [
    direnv
    dnsutils
    file
    htop
    killall
    mosh
    tmux
    vim
    wget
  ];

  developmentPackages = with pkgs; [
    git
    gitAndTools.tig
    go
    goimports
    jq
    pre-commit
    python3
  ];

  guiPackages = with pkgs; [
    feh
    firefox
    latest.rustChannels.stable.rust
    mupdf
    rxvt-unicode
    vlc
  ];

in {

  options.eth.users.eth = {
    enable = mkEnableOption "Create the user eth";

    packages = {
      development = mkOption {
        type = types.bool;
        default = false;
        description = "install development packages (Go, Git, etc)";
      };
      gui = mkOption {
        type = types.bool;
        default = false;
        description = "install GUI packages (Firefox, VLC, etc)";
      };
    };

    extraPackages = mkOption {
       type = types.listOf types.package;
       default = [];
    };
  };

  config = {

    users.users.eth = mkIf cfg.enable {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      packages = defaultPackages ++ cfg.extraPackages
        ++ (if cfg.packages.development then developmentPackages else [])
        ++ (if cfg.packages.gui         then guiPackages else []);
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqcW3HzqQxPUjZteAs5HmDbCEAtHcThnj7qfJacEXBmpO5srinU3mhV/EhrqcAMkEoEIS2az2uQQEsF13nEqDD1uZh/Q7qwEnZepzElgBOIToQ+Np2qziRExV3ROBddJfmD3XBTPc7wA5BohYku+eCsfR37ZrRTgKUIALhZ4MSRxgQqnhtgaxHpL2Nk6ZdxRHO1ISlcmiWhOETP0fj76zN4+CgSv4rkPdYxKYpWVT8XTdKgu6ENbAPbOBzplui9MmrdS17ZaWy0KrKCiyMjhA5qSsOxWLXKL9P8lRuuXkWAl5cpt3vWWKAOzlLV1UCUbtlBblyH2KkeIKfO8AC45wX keychain@eth.moe"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGf+geluXR5/hxK2OthfS+bG+7QbUVqV25bslT4KgMid+zkOVeWfA49n8/iuXUjYZmB0hP9oiFkM1wjFfC5JtET1OX3V8r0nuexXfhvG4gtWIk6Yw5HfPLv1qYYti4SrPKgQlP+C2i6WjHO6Y4VWSpJkgXgO+XvEa57fGSsjcy3rV6l/B56tpIhNchvwVxm1gHJnb4eZAKtQYcz8Pven2TFNFGLMMzQ7Y7JWAH80TDrdUywxfktaKmswo4rQ6i3zUKXrzaPuaH+egoNLqfZqM3+Q92PWs8bU2Y7uxXUQJXD32KuStRUwEz32A+O55nVVGTrnwKUUqnx9H04KCYBOVP backup@eth.moe"
      ];
    };
  };
}
