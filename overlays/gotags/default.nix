{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gotags-unstable-${version}";
  version = "2018-02-02";
  rev = "7de7045e69ff9eedb676fa40f6698c2c263e1e48";

  goPackagePath = "github.com/jstemmer/gotags";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/jstemmer/gotags";
    sha256 = "0y86i5kd42nixfzbhhm7pfkxi285x5kr8cnjkzar4g767lhxmqmc";
  };

  patches = [ ./del_testdata.patch ];

  meta = {
    description = "ctags-compatible tag generator for Go";
    homePage = "https://github.com/jstemmer/gotags";
  };
}
