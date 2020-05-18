{
  modules = {
    require = import ./module-list.nix;
  };

  overlays = import ./pkgs;
}
