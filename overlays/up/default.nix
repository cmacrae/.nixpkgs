{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "up-unstable-${version}";
  version = "2018-12-04";
  rev = "5873371e200761debda54528d2aa19a9e4c67c53";

  goPackagePath = "github.com/akavel/up";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/akavel/up";
    sha256 = "0fxp1wwi0y3kvvv13bdg2y7as0q1dazm8mab509h89s7p1g3r06r";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "up - the Ultimate Plumber";
    homePage = "https://github.com/akavel/up";
  };
}
