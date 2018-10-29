{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "up-unstable-${version}";
  version = "2018-10-24";
  rev = "5bb81d216865514df0f864d89edb04bb4906ebb5";

  goPackagePath = "github.com/akavel/up";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/akavel/up";
    sha256 = "0nn37g52v85b89fyj5b5mjs3j6r1l0a06dm31vgl2m5lyx2h214k";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "up - the Ultimate Plumber";
    homePage = "https://github.com/akavel/up";
  };
}
