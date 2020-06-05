let
  helix = builtins.fetchGit {
    url = "https://github.com/ethulhu/helix";
    rev = "e6af1aa7372e299ab6f50cfa916119082d1738cf";
  };
  recipes = builtins.fetchGit {
    url = "https://github.com/ethulhu/recipes.eth.moe";
    rev = "9c370bf0cd6a06bbcfa17e3c1f42f6ac6f92ffdb";
  };
in
  pkgs: super: {
    eth = {
      helix   = pkgs.callPackage helix   {};
      recipes = pkgs.callPackage recipes {};

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
