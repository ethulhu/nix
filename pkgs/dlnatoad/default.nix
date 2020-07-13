{ pkgs }:
with pkgs;

let
  snapshotJar = "dlnatoad-1-SNAPSHOT-jar-with-dependencies.jar";

in stdenv.mkDerivation rec {
  name = "dlnatoad-${version}";
  version = "latest";

  src = fetchFromGitHub {
    owner = "haku";
    repo = "dlnatoad";
    rev = "837e801b8da5726f25e73a4fd70c991eccc942c5";
    sha256 = "060360q4n3li773rviq8ab1931l0gfk5w9dqpc0711prng5ywqy4";
  };

  buildInputs = [
    maven
    makeWrapper
  ];

  mavenDependenciesSHA256 = "1ly6xyhyal98pbwilx23rib3vkl2q9d0wpkrxhw12gzw1417kmxp";

  fetchedMavenDeps = stdenv.mkDerivation {
    name = "dlnatoad-${version}-maven-deps";
    inherit src buildInputs;
    buildPhase = ''
      mvn \
        --threads $NIX_BUILD_CORES \
        -Dmaven.repo.local=$out/.m2 \
        -Dmaven.test.skip=true \
        dependency:resolve-plugins \
        package
    '';
    installPhase = ''
      # delete files with lastModified timestamps inside.
      find $out/.m2 -type f \! -regex '.+\(pom\|jar\|xml\|sha1\)' -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = mavenDependenciesSHA256;
  };

  buildPhase = ''
    mvn \
      --offline \
      --threads $NIX_BUILD_CORES \
      -Dmaven.test.skip=true \
      -Dmaven.repo.local=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2 \
      package
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    cp target/${snapshotJar} $out/share/java
    makeWrapper ${pkgs.jdk}/bin/java $out/bin/dlnatoad \
      --add-flags "-jar $out/share/java/${snapshotJar}"
  '';
}
