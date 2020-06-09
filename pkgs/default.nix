let
  helix = builtins.fetchGit {
    url = "https://github.com/ethulhu/helix";
    rev = "e10d1a0d38a32fd1e5971813c7c56574abecda24";
  };
  jackalope = builtins.fetchGit {
    url = "https://git.sr.ht/~eth/jackalope";
    rev = "f87cb42937a109af552a953a0e5882a81a2c343b";
  };
  recipes = builtins.fetchGit {
    url = "https://github.com/ethulhu/recipes.eth.moe";
    rev = "9c370bf0cd6a06bbcfa17e3c1f42f6ac6f92ffdb";
  };
in
  pkgs: super: {
    eth = {
      helix     = pkgs.callPackage helix     {};
      jackalope = pkgs.callPackage jackalope {};
      recipes   = pkgs.callPackage recipes   {};

      dwm = pkgs.callPackage ./dwm {};

      catbus-lifx     = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-lifx";     } ) {};
      catbus-snapcast = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-snapcast"; } ) {};
      catbus-web-ui   = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-web-ui";   } ) {};

      dlnatoad = pkgs.callPackage ./dlnatoad {};

      libnpupnp = pkgs.callPackage ./libnpupnp { };
      libupnpp  = pkgs.callPackage ./libupnpp  { };
      upmpdcli  = pkgs.callPackage ./upmpdcli  { };

      reuse = pkgs.callPackage /home/eth/src/nixpkgs/pkgs/tools/package-management/reuse {};
    };
  }
