# The version of Vault in official channels does not
# honour macOS keychain certificate authorisations.
# Here, I'm simply grabbing the precompiled binary
# directly from HashiCorp as a workaround.
# Reported: https://github.com/NixOS/nixpkgs/issues/34934
with import <nixpkgs> {};

let
  vaultBashCompletions = fetchFromGitHub {
    owner = "iljaweis";
    repo = "vault-bash-completion";
    rev = "e2f59b64be1fa5430fa05c91b6274284de4ea77c";
    sha256 = "10m75rp3hy71wlmnd88grmpjhqy0pwb9m8wm19l0f463xla54frd";
  };

in stdenv.mkDerivation rec {
  name = "vault-${version}";
  version = "0.10.3";

  src = fetchzip {
    url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_darwin_amd64.zip";
    sha256 = "07d45smhvi39319z1sxg2zgd5r4zvacgjp0hpdki5dcqvxw0jsrl";
  };

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/bash-completion/completions
    cp $src/vault $out/bin/vault
    cp ${vaultBashCompletions}/vault-bash-completion.sh $out/share/bash-completion/completions/vault
  '';
}
