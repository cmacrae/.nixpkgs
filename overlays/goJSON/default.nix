{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gojson-unstable-${version}";
  version = "2018-01-30";
  rev = "2f705cd6a603549ad1792fc0b1f9e17db6959071";

  goPackagePath = "github.com/ChimeraCoder/gojson";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/ChimeraCoder/gojson";
    sha256 = "06zxxixpm6dkh5jqb3dfsrzj14d09w4dgzg4qzs1f727kqm59hh7";
  };
}
