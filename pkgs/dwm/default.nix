{ pkgs ? import <nixpkgs> { } }:

pkgs.dwm.overrideAttrs (old: rec {
  postPatch = ''
    cp ${./config.h} ./config.h
  '';

  patches = [
  ];
})
