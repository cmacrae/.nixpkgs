{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:


buildGoPackage rec {
  name = "gometalinter-v2-unstable-${version}";
  version = "2018-02-05";
  rev = "db3d12654be9f43a073d4be01c139afd0174419d";

  goPackagePath = "gopkg.in/alecthomas/gometalinter.v2";

  src = fetchgit {
    inherit rev;
    url = "https://gopkg.in/alecthomas/gometalinter.v2";
    sha256 = "1bqgqzz8j0p45njpyf4wick00jbji9xf0mklr4rlcibxnd9n3cfd";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Concurrently run Go lint tools and normalise their output";
    homePage = "https://github.com/alecthomas/gometalinter";
  };

  postInstall = ''
    ln -sf $bin/bin/gometalinter.v2 $bin/bin/gometalinter
    '';
}
