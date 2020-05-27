# This file has been generated by mavenix-2.3.3. Configure the build here!
# https://github.com/nix-community/mavenix.

{ pkgs
, fetchgit
, mavenix ? import ./mavenix.nix { inherit pkgs; }
, doCheck ? false
}:

mavenix.buildMaven {
  inherit doCheck;

  src = fetchgit {
    url = "https://github.com/haku/dlnatoad";
    rev = "837e801b8da5726f25e73a4fd70c991eccc942c5";
    sha256 = "060360q4n3li773rviq8ab1931l0gfk5w9dqpc0711prng5ywqy4";
  };

  infoFile = ./mavenix.lock;

  buildInputs = with pkgs; [ makeWrapper ];

  postInstall = ''
    makeWrapper ${pkgs.jre_headless}/bin/java $out/bin/dlnatoad \
      --add-flags "-jar $out/share/java/dlnatoad-1-SNAPSHOT-jar-with-dependencies.jar"
  '';
}