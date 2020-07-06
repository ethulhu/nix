let
  catbus-lgtv = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-lgtv";
    rev = "b12b79b9dc40b8323bd1c010249cb2c34fc6a35e";
  };
  catbus-lifx = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-lifx";
    rev = "4dbe33adb0dcab0c40ab4da3425b490e48f61a4c";
  };
  catbus-networkpresence = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-networkpresence";
    rev = "2616ec74d18d9f04153328c8d94e3a573aac296f";
  };
  catbus-snapcast = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-snapcast";
    rev = "e0bf070ad4d9123de58589f6cc2f8c223c3929d7";
  };
  catbus-wakeonlan = builtins.fetchGit {
    url = "https://github.com/ethulhu/catbus-wakeonlan";
    rev = "e3566b5fd2a862fee38eeeafc9d5174e0a00f484";
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
  website-personal = builtins.fetchGit {
    url = "https://git.eth.moe/website-personal";
    rev = "b1e6491f77421ae4623391a7f53af7f3e6c13f34";
  };
in
  pkgs: super: {
    eth = {
      helix     = pkgs.callPackage helix     {};
      jackalope = pkgs.callPackage jackalope {};
      recipes   = pkgs.callPackage recipes   {};

      website-personal = pkgs.callPackage website-personal {};

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
