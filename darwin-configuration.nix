{ config, lib, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {};
  apps = import ./pkgs/apps.nix;

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
    # macOS Applicatiions
    (import ./pkgs/apps.nix)
    (self: super:
      {
        # Go linting
        gometalinter = super.callPackage ./overlays/goMetaLinter {};
        goconst = super.callPackage ./overlays/goMetaLinter/linters/goconst {};
        gas = super.callPackage ./overlays/goMetaLinter/linters/gas {};
        deadcode = super.callPackage ./overlays/goMetaLinter/linters/deadcode {};
        maligned = super.callPackage ./overlays/goMetaLinter/linters/maligned {};
        structcheck = super.callPackage ./overlays/goMetaLinter/linters/structcheck {};
        gocyclo = super.callPackage ./overlays/goMetaLinter/linters/gocyclo {};
        errcheck = super.callPackage ./overlays/goMetaLinter/linters/errcheck {};
        unconvert = super.callPackage ./overlays/goMetaLinter/linters/unconvert {};

        # Go REPL
        gore = super.callPackage ./overlays/gore {};

        # Go JSON
        goJSON = super.callPackage ./overlays/goJSON {};

        # Terraform provisioner Ansible
        terraformProvisionerAnsible = super.callPackage ./overlays/terraform-provisioner-ansible {};

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
    # macOS Applications
    Caffeine
    BeardedSpice
    Docker
    Firefox
    iTerm2
    Rocket

    # General
    ansible
    aspell
    aspellDicts.en
    aspellDicts.uk
    awscli
    bash
    browserpass
    curl
    cmus
    emacs
    ffmpeg
    git
    gnupg
    gnused
    httpie
    id3lib
    ipcalc
    ipfs
    jq
    unstable.mpv
    ncat
    nodejs
    openssh
    pass
    pwgen
    ripgrep
    rsync
    tree
    wget
    youtube-dl

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
    terraformProvisionerAnsible

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
    goJSON
    # ineffassign FIXME
    # megacheck FIXME
    # interfacer FIXME

    # Nix
    nix
    nix-repl
    nix-prefetch-git
  ];

  environment.systemPath = [
      "${pkgs.Docker}/Applications/Docker.app/Contents/Resources/bin"
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

  # Screencap location
  system.defaults.screencapture.location = "/tmp";

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
}
