{ pkgs ? import <nixpkgs> {}
, autoconf
, jsoncpp
, autoreconfHook
, curl
, fetchgit
, libmicrohttpd
, libupnpp ? pkgs.eth.libupnpp
, mpd_clientlib
, pkgconfig
, stdenv
}:

stdenv.mkDerivation rec {
  name = "upmpdcli-${version}";
  version = "latest"; 

  src = fetchgit {
    url = "https://framagit.org/medoc92/upmpdcli.git";
    rev = "898b202b9c23be423775207a5407046a1e70fd52";
    sha256 = "0i25za83r2rgipx3m72n8cma7s2jqibvgm6r0kh4kcy2rlxwz0kv";
  };

  nativeBuildInputs = [
    autoconf
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    jsoncpp
    curl.dev
    libmicrohttpd
    libupnpp
    mpd_clientlib
  ];

  meta = {
    description = "An UPnP Audio Media Renderer based on MPD";
    homepage = "https://www.lesbonscomptes.com/upmpdcli/";
    license = stdenv.lib.licenses.lgpl21;
  };
}
