# The version of Vault in official channels does not
# honor macOS keychain certificate authorizations.
# Here, I'm simply grabbing the precompiled binary
# directly from HashiCorp as a workaround.
with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "vault-${version}";
  version = "0.9.3";

  src = fetchzip {
    url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_darwin_amd64.zip";
    sha256 = "0angapmlzm4xr724wj17d7siywfh0x6k215llvlrf0v5ja8xprng";
  };

  phases = "unpackPhase";
  unpackPhase = ''
    mkdir -p $out/bin
    cp $src/vault $out/bin/vault
    '';
}
