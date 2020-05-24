pkgs: super: {
  eth = {
    recipesEthMoe = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/recipes.eth.moe"; } ) {};

    dwm = pkgs.callPackage ./dwm {};

    catbus-lifx     = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-lifx";     } ) {};
    catbus-snapcast = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-snapcast"; } ) {};
    catbus-web-ui   = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-web-ui";   } ) {};

    helix = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/helix"; rev = "142be94fb81ee3ff7aba1694836fd45330d22862"; } ) {};

    libnpupnp = pkgs.callPackage ./libnpupnp { };
    libupnpp  = pkgs.callPackage ./libupnpp  { };
    upmpdcli  = pkgs.callPackage ./upmpdcli  { };

    reuse = pkgs.callPackage /home/eth/src/nixpkgs/pkgs/tools/package-management/reuse {};
  };
}
