pkgs: super: {
  eth = {
    recipesEthMoe = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/recipes.eth.moe"; } ) {};

    dwm = pkgs.callPackage ./dwm {};

    catbus-lifx     = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-lifx";     } ) {};
    catbus-snapcast = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-snapcast"; } ) {};
    catbus-web-ui   = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-web-ui";   } ) {};

    helix = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/helix"; rev = "6162800302ac41bcacded9916260827bbf5ac99e"; } ) {};

    dlnatoad = pkgs.callPackage ./dlnatoad {};

    libnpupnp = pkgs.callPackage ./libnpupnp { };
    libupnpp  = pkgs.callPackage ./libupnpp  { };
    upmpdcli  = pkgs.callPackage ./upmpdcli  { };

    reuse = pkgs.callPackage /home/eth/src/nixpkgs/pkgs/tools/package-management/reuse {};
  };
}
