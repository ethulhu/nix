# Eth's Misc Nix Mix

```sh
$ cat /etc/nixos/configuration.nix
{ config, pkgs, ... }:

let
  ethNixLocal = import /home/eth/src/nix;
  ethNixRemote = import ( builtins.fetchGit { url = "https://github.com/ethulhu/nix"; } );

  ethNix = ethNixRemote;

in {
  imports = [
    ./hardware-configuration.nix
    ethNix.modules
  ];

  nixpkgs.overlays = [
    ethNix.overlays;
  ];

  eth.keyboard.enable = true;
}
```
