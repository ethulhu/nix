# Eth's Misc Nix Mix

```sh
$ cat /etc/nixos/configuration.nix
{ config, pkgs, ... }:

let
  ethNix = import /home/eth/src/nix;
{
  imports = [
    ./hardware-configuration.nix
    ethNix.modules
  ];

  eth.keyboard.enable = true;
}
```
