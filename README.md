# Eth's Misc Nix Mix

```sh
$ cat /etc/nixos/configuration.nix
{ config, pkgs, ... }:

let
  ethNixLocal = import /home/eth/src/nix;
  ethNix = import ( builtins.fetchGit { url = "https://github.com/ethulhu/nix"; } );
{
  imports = [
    ./hardware-configuration.nix
    ethNix.modules
  ];

  eth.keyboard.enable = true;
}
```
