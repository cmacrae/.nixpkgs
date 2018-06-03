{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

let home = builtins.getEnv "HOME";

in buildGoPackage rec {
  name = "terraform-provisioner-ansible-unstable-${version}";
  version = "2018-04-27";
  rev = "f7bc8b58efffbd8a22f0fa8e0ce409037123d82e";

  goPackagePath = "github.com/radekg/terraform-provisioner-ansible";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/radekg/terraform-provisioner-ansible.git";
    sha256 = "0kp20giykr6k7akvnlwd2bcfj7cciqc5mhd1k8cid5xfi86p83xv";
  };

  goDeps = ./deps.nix;

  # This requires ~/.terraform/plugins to be 0777
  # if using the Nix build daemon
  postInstall = ''
    ln -sf $bin/bin/terraform-provisioner-ansible \
    ${home}/.terraform.d/plugins/terraform-provisioner-ansible
  '';
}
