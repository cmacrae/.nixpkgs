{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "up-unstable-${version}";
  version = "2018-10-31";
  rev = "804be3cfb8982f83e850f28bef5730672b6d04da";

  goPackagePath = "github.com/akavel/up";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/akavel/up";
    sha256 = "171bwbk2c7jbi51xdawzv7qy71492mfs9z5j0a5j52qmnr4vjjgs";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "up - the Ultimate Plumber";
    homePage = "https://github.com/akavel/up";
  };
}
