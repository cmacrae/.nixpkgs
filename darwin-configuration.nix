{ config, lib, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {};
  home = builtins.getEnv "HOME";

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

  nixpkgs.overlays = [
    # macOS Applicatiions
    (import ./pkgs/apps.nix)

    # Orverlays
    (self: super:
      {
        # Go
        gometalinter = super.callPackage ./overlays/goMetaLinter {};
        goconst = super.callPackage ./overlays/goconst {};
        gas = super.callPackage ./overlays/gas {};
        deadcode = super.callPackage ./overlays/deadcode {};
        maligned = super.callPackage ./overlays/maligned {};
        structcheck = super.callPackage ./overlays/structcheck {};
        gocyclo = super.callPackage ./overlays/gocyclo {};
        errcheck = super.callPackage ./overlays/errcheck {};
        unconvert = super.callPackage ./overlays/unconvert {};
        gore = super.callPackage ./overlays/gore {};
        goJSON = super.callPackage ./overlays/goJSON {};
        gotags = super.callPackage ./overlays/gotags {};

        # Terraform provisioner Ansible
        terraformProvisionerAnsible = super.callPackage ./overlays/terraform-provisioner-ansible {};

        # up - Ultimate Plumber
        up = super.callPackage ./overlays/up {};

        # Broken Go linting packages
        # megacheck = super.callPackage ./overlays/megacheck/main.nix {}; FIXME
        # ineffassign = super.callPackage ./overlays/ineffassign/main.nix {}; FIXME
        # interfacer = super.callPackage ./overlays/interfacer/main.nix {}; FIXME
      }
    )
  ];


  # Packages
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # macOS Applications
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
    lastpass-cli
    unstable.mpv
    ncat
    nodejs
    openssh
    pandoc
    pass
    pwgen
    ripgrep
    rsync
    tree
    wget
    youtube-dl

    # Kubernetes
    kail
    kops
    kubernetes
    kubernetes-helm
    minikube

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
    gotags
    # ineffassign FIXME
    # megacheck FIXME
    # interfacer FIXME
    up

    # Nix
    nix
    nix-prefetch-git
  ];

  environment.extraOutputsToInstall = [ "man" ];
  environment.variables = {
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


  environment.systemPath = ["${home}/bin"];

  # tmux
  programs.tmux = {
    enable = true;
    enableVim = true;
    tmuxConfig = (import ./conf/tmux.conf);
  };

  # Shell configuration
  environment.etc."shells".text = ''
    /bin/bash
    /bin/csh
    /bin/ksh
    /bin/sh
    /bin/tcsh
    /run/current-system/sw/bin/zsh
    /bin/zsh
  '';

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
  # Global Emacs keybindings
  environment.etc."keybindings".text = (import ./conf/DefaultKeyBinding.dict);
  system.activationScripts.extraUserActivation.text = ''
    install -d -o cmacrae -g staff ${home}/Library/KeyBindings
    ln -sfn /etc/keybindings ${home}/library/keybindings/DefaultKeyBinding.dict
  '';

  # Services
  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
}
