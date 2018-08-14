{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "interfacer-unstable-${version}";
  version = "2017-09-08";
  rev = "d7e7372184a059b8fd99d96a593e3811bf989d75";

  goPackagePath = "mvdan.cc/interfacer";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/mvdan/interfacer";
    sha256 = "0kc0ny4i7g983rs57qb361jnaamd2vgikq92n9cw4rfdprsk4lpm";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A linter that suggests interface types";
    homePage = "https://github.com/mvdan/interfacer";
  };
}
