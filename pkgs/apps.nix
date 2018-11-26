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

  Firefox = self.installApplication rec {
    name = "Firefox";
    version = "63.0.3";
    sourceRoot = "Firefox.app";
    src = super.fetchurl {
      name = "Firefox-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
      sha256 = "0am911fswgg3s3888f5938nyzi6y0bkj8i6bibikr338xjp6vj8s";
    };
    description = "Free and open-source web browser developed by Mozilla Foundation";
    homepage = https://www.mozilla.org/en-US/firefox;
  };

  iTerm2 = self.installApplication rec {
    inherit (builtins) replaceStrings;
    name = "iTerm2";
    appname = "iTerm";
    version = "3.2.0";
    sourceRoot = "iTerm.app";
    src = super.fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-${replaceStrings ["\."] ["_"] version}.zip";
      sha256 = "19121a3hdqvsm6l778s7myfm8z61ss8c0g8rlwlvypbfdybn4j3x";
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
      sha256 = "15jc6fg2q69cspjhdq3r4v2hx5m2ml089xp31lfa18rdwncyklq8";
    };
    description = "Mind-blowing emoji on your Mac";
    homepage = https://matthewpalmer.net/rocket/;
  };
}
