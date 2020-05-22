{ pkgs ? import <nixpkgs> {}
, autoconf
, autoreconfHook
, curl
, expat
, fetchgit
, libmicrohttpd
, pkgconfig
, stdenv
}:

stdenv.mkDerivation rec {
  name = "libnpupnp-${version}";
  version = "latest"; 

  src = fetchgit {
    url = "https://framagit.org/medoc92/npupnp.git";
    rev = "98433263968de83f13416bf096a31fa354a646fa";
    sha256 = "0i5hd7pbmcdhh46hqf50881jbl7ycv3gpvczbpzkx5ffbnpxxika";
  };

  nativeBuildInputs = [
    autoconf
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    curl.dev
    expat
    libmicrohttpd
  ];

  meta = {
    description = "A C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp";
    homepage = "https://framagit.org/medoc92/npupnp";
    license = stdenv.lib.licenses.bsd3;
  };
}
