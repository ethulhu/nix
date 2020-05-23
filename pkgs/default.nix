pkgs: super: {
  eth = {
    recipesEthMoe = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/recipes.eth.moe"; } ) {};

    catbus-snapcast = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-snapcast"; } ) {};
    catbus-lifx     = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/catbus-lifx";     } ) {};

    helix = pkgs.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/helix"; rev = "142be94fb81ee3ff7aba1694836fd45330d22862"; } ) {};

    libnpupnp = pkgs.callPackage ./libnpupnp { };
    libupnpp  = pkgs.callPackage ./libupnpp  { };
    upmpdcli  = pkgs.callPackage ./upmpdcli  { };
  };
}
