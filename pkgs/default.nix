let
  catbus-lifx = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-lifx";
    # TODO: rev = "...";
  };
  catbus-snapcast = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-snapcast";
    # TODO: rev = "...";
  };
  catbus-wakeonlan = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-wakeonlan";
    rev = "5b9435bff8ce11bbbf720084e27c2c6f471934f6";
  };
  catbus-web-ui = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-web-ui";
    # TODO: rev = "...";
  };
  helix = builtins.fetchGit {
    url = "https://github.com/ethulhu/helix";
    rev = "b308ffcd9182942df93ceed7b57fe46a049aa505";
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

      catbus-lifx      = pkgs.callPackage catbus-lifx      {};
      catbus-snapcast  = pkgs.callPackage catbus-snapcast  {};
      catbus-wakeonlan = pkgs.callPackage catbus-wakeonlan {};
      catbus-web-ui    = pkgs.callPackage catbus-web-ui    {};

      dlnatoad = pkgs.callPackage ./dlnatoad {};

      libnpupnp = pkgs.callPackage ./libnpupnp { };
      libupnpp  = pkgs.callPackage ./libupnpp  { };
      upmpdcli  = pkgs.callPackage ./upmpdcli  { };

      reuse = pkgs.callPackage /home/eth/src/nixpkgs/pkgs/tools/package-management/reuse {};
    };
  }
