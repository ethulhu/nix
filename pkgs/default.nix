let
  recipes = builtins.fetchGit {
    url = "https://github.com/ethulhu/recipes.eth.moe";
    rev = "9c370bf0cd6a06bbcfa17e3c1f42f6ac6f92ffdb";
  };
in
  pkgs: super: {
    eth = {
      recipes = pkgs.callPackage recipes {};

      dwm = pkgs.callPackage ./dwm {};

      catbus-lifx     = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-lifx";     } ) {};
      catbus-snapcast = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-snapcast"; } ) {};
      catbus-web-ui   = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-web-ui";   } ) {};

      helix = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/helix"; rev = "eb0335d0d1810187ea054c5960e11bd2e90f771b"; } ) {};

      dlnatoad = pkgs.callPackage ./dlnatoad {};

      libnpupnp = pkgs.callPackage ./libnpupnp { };
      libupnpp  = pkgs.callPackage ./libupnpp  { };
      upmpdcli  = pkgs.callPackage ./upmpdcli  { };

      reuse = pkgs.callPackage /home/eth/src/nixpkgs/pkgs/tools/package-management/reuse {};
    };
  }
