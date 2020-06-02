pkgs: super: {
  eth = {
    recipesEthMoe = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/recipes.eth.moe"; } ) {};

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
