self: super: {

installApplication =
  { name, appname ? name, version, src, description, homepage,
    postInstall ? "", sourceRoot ? ".", ... }:
  with super; stdenv.mkDerivation {
    name = "${name}-${version}";
    version = "${version}";
    src = src;
    buildInputs = [ undmg unzip ];
    sourceRoot = sourceRoot;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p "$out/Applications/${appname}.app"
      cp -pR * "$out/Applications/${appname}.app"
    '' + postInstall;
    meta = with stdenv.lib; {
      description = description;
      homepage = homepage;
      maintainers = with maintainers; [ cmacrae ];
      platforms = platforms.darwin;
    };
  };

  Caffeine = self.installApplication rec {
    name = "Caffeine";
    appname = "Caffeine";
    version = "1.1.1";
    sourceRoot = "Caffeine.app";
    src = super.fetchurl {
      url = http://lightheadsw.com/files/releases/com.lightheadsw.Caffeine/Caffeine1.1.1.zip;
      sha256 = "0lqqllpg72nn6k5ksd8bzw0x9gpprqfypfwlq8db9apra44w60wj";
    };
    description = ''
      Caffeine is a tiny program that puts an icon in the right side of your menu bar. Click it to prevent your Mac from automatically going to sleep, dimming the screen or starting screen savers
    '';
    homepage = http://lightheadsw.com/caffeine/;
  };

  BeardedSpice = self.installApplication rec {
    name = "BeardedSpice";
    appname = "BeardedSpice";
    version = "2.2.3";
    sourceRoot = "BeardedSpice.app";
    src = super.fetchurl {
      url = https://raw.github.com/beardedspice/beardedspice/distr/publish/releases/BeardedSpice-latest.zip;
      sha256 = "09hb2nf22izmv08yiqs1rdd8hrwh4w8wn2ra1nj6v2kdbm532rrq";
    };
    description = ''
      BeardedSpice is a menubar application for Mac OSX that allows you to control web based media players and some native apps with the media keys found on Mac keyboards
    '';
    homepage = https://beardedspice.github.io/;
  };

  Docker = self.installApplication rec {
    name = "Docker";
    version = "18.03.1-ce-mac65";
    sourceRoot = "Docker.app";
    src = super.fetchurl {
      url = https://download.docker.com/mac/stable/Docker.dmg;
      sha256 = "1hkgi3fm04rinjfzs64p1f34q351rrzwwk5ga1jvyxvk88bj73k7";
    };
    description = ''
      Docker CE for Mac is an easy-to-install desktop app for building,
      debugging, and testing Dockerized apps on a Mac
    '';
    homepage = https://store.docker.com/editions/community/docker-ce-desktop-mac;
  };

  Firefox = self.installApplication rec {
    name = "Firefox";
    version = "61.0.1";
    sourceRoot = "Firefox.app";
    src = super.fetchurl {
      name = "Firefox-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
      sha256 = "13sx6y6585dgvy4rrmcsilbvqblzn6fyi7nz1h3jbyh56ws4fbkc";
    };
    postInstall = ''
      for file in  \
          $out/Applications/Firefox.app/Contents/MacOS/firefox \
          $out/Applications/Firefox.app/Contents/MacOS/firefox-bin
      do
          dir=$(dirname "$file")
          base=$(basename "$file")
          mv $file $dir/.$base
          cat > $file <<'EOF'
  #!/bin/bash
  export PATH=${super.gnupg}/bin:${super.pass}/bin:$PATH
  export PASSWORD_STORE_ENABLE_EXTENSIONS="true"
  export PASSWORD_STORE_EXTENSIONS_DIR="/run/current-system/sw/lib/password-store/extensions";
  export PASSWORD_STORE_DIR="$HOME/.password-store";
  export GNUPGHOME="$HOME/.config/gnupg"
  export GPG_TTY=$(tty)
  if ! pgrep -x "gpg-agent" > /dev/null; then
  ${super.gnupg}/gpgconf --launch gpg-agent
  fi
  dir=$(dirname "$0")
  name=$(basename "$0")
  exec "$dir"/."$name" "$@"
  EOF
          chmod +x $file
      done
    '';
    description = "Free and open-source web browser developed by Mozilla Foundation";
    homepage = https://www.mozilla.org/en-US/firefox;
  };

  iTerm2 = self.installApplication rec {
    name = "iTerm2";
    appname = "iTerm";
    version = "3.1.7";
    sourceRoot = "iTerm.app";
    src = super.fetchurl {
      url = https://iterm2.com/downloads/stable/iTerm2-3_1_7.zip;
      sha256 = "1phy5dcfh8gq8crzchphs663xpicd3bddxzyprjsybpy88y6njfm";
    };
    description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com;
  };

  Rocket = self.installApplication rec {
    name = "Rocket";
    appname = "Rocket";
    version = "1.4";
    sourceRoot = "Rocket.app";
    src = super.fetchurl {
      url = https://dl.devmate.com/net.matthewpalmer.Rocket/Rocket.dmg;
      sha256 = "1a7v07h3r2jlhya1afnmrqv7rl8y8clv331m9jkh3p8af2r0rc5i";
    };
    description = "Mind-blowing emoji on your Mac";
    homepage = https://matthewpalmer.net/rocket/;
  };
}
