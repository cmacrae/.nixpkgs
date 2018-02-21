{ config, lib, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {};

  # Custom packages
  # See relevant import paths for details
  customPkg = {
    vault = (import ./pkgs/vault/default.nix);
  };

in {

  # Nix config
  system.stateVersion = 2;
  nix.maxJobs = 8;
  nix.trustedUsers = [ "cmacrae" ];
  nix.gc.automatic = true;

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
    openssh
    pass
    pwgen
    ripgrep
    rsync
    ruby
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
    GOWORKSPACE = "$GOPATH/src/github.com/cmacrae";
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

  # tmux
  programs.tmux = {
    enable = true;
    enableVim = true;
    iTerm2 = true;
    tmuxConfig = (import ./conf/tmux.conf);
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableSyntaxHighlighting = true;
    promptInit = "autoload -Uz promptinit && promptinit";
    interactiveShellInit = (import ./conf/interactiveShellInit.zsh);
  };

  # System
  # Time
  time.timeZone = "Europe/London";

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
  services.kwm.kwmConfig = (import ./conf/kwm.conf);
  services.khd.khdConfig = (import ./conf/khd.conf);
}
