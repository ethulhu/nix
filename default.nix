{
  modules = {
    require = import ./nixos/modules/module-list.nix;
  };

  sites = import ./nixos/sites;

  overlays = import ./pkgs;
}
