{ config, lib, pkgs, ... }:
with lib;

let 
  cfg = config.eth.users.eth;

  defaultPackages = with pkgs; [
    home-manager

    ag
    direnv
    dnsutils
    file
    git
    gitAndTools.tig
    go
    htop
    iotop
    killall
    moreutils
    mosh
    python3
    rlwrap
    screen
    tmux
    unzip
    vim
    wget
    zip
  ];

in {

  options.eth.users.eth = {
    enable = mkEnableOption "Create the user eth";

    extraPackages = mkOption {
       type = types.listOf types.package;
       default = [];
    };
  };

  config = {

    users.users.eth = mkIf cfg.enable {
      isNormalUser = true;

      extraGroups = [ "dialout" "wheel" ] ++
        (if config.programs.wireshark.enable then [ "wireshark" ] else []);

      shell = pkgs.fish;

      packages = defaultPackages ++ cfg.extraPackages;

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqcW3HzqQxPUjZteAs5HmDbCEAtHcThnj7qfJacEXBmpO5srinU3mhV/EhrqcAMkEoEIS2az2uQQEsF13nEqDD1uZh/Q7qwEnZepzElgBOIToQ+Np2qziRExV3ROBddJfmD3XBTPc7wA5BohYku+eCsfR37ZrRTgKUIALhZ4MSRxgQqnhtgaxHpL2Nk6ZdxRHO1ISlcmiWhOETP0fj76zN4+CgSv4rkPdYxKYpWVT8XTdKgu6ENbAPbOBzplui9MmrdS17ZaWy0KrKCiyMjhA5qSsOxWLXKL9P8lRuuXkWAl5cpt3vWWKAOzlLV1UCUbtlBblyH2KkeIKfO8AC45wX keychain@eth.moe"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGf+geluXR5/hxK2OthfS+bG+7QbUVqV25bslT4KgMid+zkOVeWfA49n8/iuXUjYZmB0hP9oiFkM1wjFfC5JtET1OX3V8r0nuexXfhvG4gtWIk6Yw5HfPLv1qYYti4SrPKgQlP+C2i6WjHO6Y4VWSpJkgXgO+XvEa57fGSsjcy3rV6l/B56tpIhNchvwVxm1gHJnb4eZAKtQYcz8Pven2TFNFGLMMzQ7Y7JWAH80TDrdUywxfktaKmswo4rQ6i3zUKXrzaPuaH+egoNLqfZqM3+Q92PWs8bU2Y7uxXUQJXD32KuStRUwEz32A+O55nVVGTrnwKUUqnx9H04KCYBOVP backup@eth.moe"
      ];
    };
  };
}
