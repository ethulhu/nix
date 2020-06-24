let
  catbus-lgtv = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-lgtv";
    rev = "6184414321f7f633dbb71cf70ed336e1c42d9d9e";
  };
  catbus-lifx = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-lifx";
    # TODO: rev = "...";
  };
  catbus-networkpresence = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-networkpresence";
    rev = "da8002ab10174ccdbbd1718069b7de36afe2dc46";
  };
  catbus-snapcast = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-snapcast";
    # TODO: rev = "...";
  };
  catbus-wakeonlan = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-wakeonlan";
    rev = "54d24cbc56c012f30de902c2746899ffbf9154eb";
  };
  catbus-web-ui = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-web-ui";
    # TODO: rev = "...";
  };
  helix = builtins.fetchGit {
    url = "https://github.com/ethulhu/helix";
    rev = "b64bdc80c3c994f22a28599747897aa5de3ada93";
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

      catbus-lgtv            = pkgs.callPackage catbus-lgtv            {};
      catbus-lifx            = pkgs.callPackage catbus-lifx            {};
      catbus-networkpresence = pkgs.callPackage catbus-networkpresence {};
      catbus-snapcast        = pkgs.callPackage catbus-snapcast        {};
      catbus-wakeonlan       = pkgs.callPackage catbus-wakeonlan       {};
      catbus-web-ui          = pkgs.callPackage catbus-web-ui          {};

      dlnatoad = pkgs.callPackage ./dlnatoad {};

      libnpupnp = pkgs.callPackage ./libnpupnp { };
      libupnpp  = pkgs.callPackage ./libupnpp  { };
      upmpdcli  = pkgs.callPackage ./upmpdcli  { };

      reuse = pkgs.callPackage /home/eth/src/nixpkgs/pkgs/tools/package-management/reuse {};
    };
  }
