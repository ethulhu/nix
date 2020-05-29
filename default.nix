{
  modules = {
    require = import ./nixos/modules/module-list.nix;
  };

  overlays = import ./pkgs;
}
