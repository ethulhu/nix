{ pkgs ? import <nixpkgs> {}
, autoconf
, autoreconfHook
, curl
, expat
, fetchgit
, libmicrohttpd
, libnpupnp ? pkgs.eth.libnpupnp
, pkgconfig
, stdenv
}:

stdenv.mkDerivation rec {
  name = "libupnpp-${version}";
  version = "latest"; 

  src = fetchgit {
    url = "https://framagit.org/medoc92/libupnpp.git";
    rev = "762e35f4f66df183b8df8b1fc4dbab187068441d";
    sha256 = "085virkyz8cp55kd6k3zadhclh10qi78ijd84dnbmk852w57xsx9";
  };

  nativeBuildInputs = [
    autoconf
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    curl.dev
    libnpupnp
    expat
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A higher level C++ API over libnpupnp or libupnp";
    homepage = "https://www.lesbonscomptes.com/upmpdcli/libupnpp-refdoc/libupnpp-ctl.html";
    license = stdenv.lib.licenses.lgpl21;
  };
}
