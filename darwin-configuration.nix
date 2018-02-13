{ config, lib, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {};

  # Custom packages
  # See relevant import paths for details
  customPkg = {
    vault = (import ./pkgs/vault/default.nix);
  };

in {
  system.stateVersion = 2;
  nix.maxJobs = 4;
  nix.trustedUsers = [ "cmacrae" ];

  nixpkgs.overlays = [
    (self: super:
      {
        # Go linting
        gometalinter = super.callPackage ./overlays/goMetaLinter/default.nix {};
        goconst = super.callPackage ./overlays/goMetaLinter/linters/goconst/default.nix {};
        gas = super.callPackage ./overlays/goMetaLinter/linters/gas/default.nix {};
        deadcode = super.callPackage ./overlays/goMetaLinter/linters/deadcode/default.nix {};
        maligned = super.callPackage ./overlays/goMetaLinter/linters/maligned/default.nix {};
        structcheck = super.callPackage ./overlays/goMetaLinter/linters/structcheck/default.nix {};
        gocyclo = super.callPackage ./overlays/goMetaLinter/linters/gocyclo/default.nix {};
        errcheck = super.callPackage ./overlays/goMetaLinter/linters/errcheck/default.nix {};
        unconvert = super.callPackage ./overlays/goMetaLinter/linters/unconvert/default.nix {};

        # Go REPL
        gore = super.callPackage ./overlays/gore/default.nix {};

        # Broken Go linting packages
        # megacheck = super.callPackage ./overlays/goMetaLinter/linters/megacheck/main.nix {}; FIXME
        # ineffassign = super.callPackage ./overlays/goMetaLinter/linters/ineffassign/main.nix {}; FIXME
        # interfacer = super.callPackage ./overlays/goMetaLinter/linters/interfacer/main.nix {}; FIXME
      }
    )
  ];

  # Packages
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # General
    ansible
    aspell
    aspellDicts.en
    aspellDicts.uk
    awscli
    bash
    curl
    cmus
    emacs
    git
    gnupg
    gnused
    id3lib
    ipcalc
    ipfs
    jq
    ncat
    nodejs
    mysql
    openssh
    pass
    pwgen
    ripgrep
    rsync
    ruby
    tmux
    tree
    wget

    # Go
    unstable.go
    unstable.gocode
    unstable.godef
    unstable.gotools
    unstable.golint
    unstable.go2nix

    # HashiCorp
    unstable.consul
    unstable.consul-template
    unstable.packer
    unstable.terraform
    customPkg.vault

    # Overlays
    gometalinter
    goconst
    gas
    deadcode
    maligned
    structcheck
    gocyclo
    errcheck
    unconvert
    gore
    # ineffassign FIXME
    # megacheck FIXME
    # interfacer FIXME

    # Nix
    nix
    nix-repl
    nix-prefetch-git
  ];

  environment.extraOutputsToInstall = [ "man" ];
  environment.variables = {
    # Nix
    NIX_REMOTE = "daemon";

    # General
    HOME = "/Users/cmacrae";
    GOROOT = "${unstable.go}/share/go";
    GOPATH = "$HOME/code/go";
    GOWORKSPACE = "$HOME/code/go/src/github.com/cmacrae";
    PAGER = "less -R";
    EDITOR = "emacsclient";

    # History
    HISTSIZE = "1000";
    SAVEHIST = "1000";
    HISTFILE = "$HOME/.history";

    # Terminfo
    TERMINFO = "/usr/share/terminfo/";
  };

  environment.shellAliases = {
      ls = "ls -G";
      rm = "rm -i";
      cp = "cp -i";
      gows = "cd $GOWORKSPACE";
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableSyntaxHighlighting = true;
    promptInit = "autoload -Uz promptinit && promptinit";
    interactiveShellInit = ''
      autoload -Uz zutil
      autoload -Uz complist
      autoload -Uz colors && colors

      setopt   correct always_to_end notify
      setopt   nobeep autolist autocd print_eight_bit
      setopt   append_history share_history globdots
      setopt   pushdtohome cdablevars recexact longlistjobs
      setopt   autoresume histignoredups pushdsilent noclobber
      setopt   autopushd pushdminus extendedglob rcquotes
      unsetopt bgnice autoparamslash

      # Emacs bindings & fix reverse search in tmux
      bindkey -e
      bindkey '^R' history-incremental-search-backward

      export PATH=${config.environment.systemPath}:$GOPATH/bin

      # Prompts
      if [[ ! -n $INSIDE_EMACS ]]; then
      export "PROMPT=
      %{$fg[blue]%}%n %{$fg[red]%}$ %{$reset_color%}"
      export "RPROMPT=%{$fg[blue]%}%~%f%b"
      else
      export "PROMPT=
      %{$fg[blue]%}%~ %{$fg[red]%}$ %f%b"
      fi
    '';
  };

  # Dock configuration
  system.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    minimize-to-application = true;
  };

  # Finder configuration
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    _FXShowPosixPathInTitle = true;
    FXEnableExtensionChangeWarning = false;
  };

  # Trackpad
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadThreeFingerDrag = true;
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Services
  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;

  # kwm/khd
  services.khd.enable = true;
  services.kwm.enable = true;
  services.kwm.kwmConfig = ''
    # Window behaviour
    kwmc config tiling bsp
    kwmc config float-non-resizable on
    kwmc config lock-to-container on
    kwmc config focus-follows-mouse on
    kwmc config mouse-follows-focus on
    kwmc config standby-on-float on
    kwmc config center-on-float on
    kwmc config mouse-drag on
    kwmc config mouse-drag mod cmd+ctrl
    kwmc config cycle-focus off
    kwmc config split-ratio 0.5
    kwmc config spawn left

    # Rules
    kwmc rule owner="iTerm" properties={display="1"}

    # Padding/gaps
    kwmc config padding 40 40 40 40
    kwmc config gap 20 20

    # Borders
    kwmc config border focused off
    kwmc config border focused size 1
    kwmc config border focused color 0xFF5fb3b3
    kwmc config border focused radius 6
    kwmc config border marked off
    kwmc config border marked size 2
    kwmc config border marked color 0xFF6299ca
    kwmc config border marked radius 6
  '';

  services.khd.khdConfig = ''
    # kwm compatibility mode
    khd kwm on

    # Navigation
    cmd + lctrl - h    :   kwmc window -f west
    cmd + lctrl - j    :   kwmc window -f south
    cmd + lctrl - k    :   kwmc window -f north
    cmd + lctrl - l    :   kwmc window -f east

    # Window movement
    cmd + shift - h   :   kwmc window -s west
    cmd + shift - j   :   kwmc window -s south
    cmd + shift - k   :   kwmc window -s north
    cmd + shift - l   :   kwmc window -s east

    cmd + shift + lctrl - h   :   kwmc window -m west
    cmd + shift + lctrl - j   :   kwmc window -m south
    cmd + shift + lctrl - l   :   kwmc window -m east
    cmd + shift + lctrl - k   :   kwmc window -m north

    cmd + lctrl - r           :   kwmc tree rotate 90

    # Space movement
    cmd + lctrl - 1   :   kwmc space -fExperimental 1
    cmd + lctrl - 2   :   kwmc space -fExperimental 2
    cmd + lctrl - 3   :   kwmc space -fExperimental 3
    cmd + lctrl - 4   :   kwmc space -fExperimental 4
    cmd + lctrl - 5   :   kwmc space -fExperimental 5
    cmd + lctrl - 6   :   kwmc space -fExperimental 6

    #cmd - "["            :   kwmc space -fExperimental left
    #cmd - "["            :   kwmc space -fExperimental right
    #cmd - "{"            :   kwmc space -fExperimental previous

    # Layout manipulation
    cmd + lctrl - t   :   kwmc space -t bsp
    cmd + lctrl - m   :   kwmc space -t monocle
    cmd + lctrl - s   :   kwmc space -t float
    cmd + lctrl - f   :   kwmc window -z fullscreen

    # Window portion manipulation
    cmd + lctrl - x               :   kwmc space -g increase horizontal
    cmd + lctrl - y               :   kwmc space -g increase vertical

    cmd + shift + lctrl - x       :   kwmc space -g decrease horizontal
    cmd + shift + lctrl - y       :   kwmc space -g decrease vertical
  '';
}
