{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gore-unstable-${version}";
  version = "2017-10-11";
  rev = "82b24d9e914e0f24ec9276659d608d918743803f";

  goPackagePath = "github.com/motemen/gore";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/motemen/gore";
    sha256 = "1jdafc23l4dzr2klj09746xykpc0c028nkqg2x9dwh353gc2m9r0";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Go REPL";
    homePage = "https://github.com/motemen/gore";
  };
}
