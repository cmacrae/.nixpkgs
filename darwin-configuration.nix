{ config, lib, pkgs, ... }:

{
  # Packages
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.ansible
    pkgs.aspell
    pkgs.aspellDicts.en
    pkgs.aspellDicts.uk
    pkgs.awscli
    pkgs.bash
    pkgs.curl
    pkgs.emacs
    pkgs.git
    pkgs.gnupg
    pkgs.gnused
    pkgs.go
    pkgs.jq
    pkgs.lastpass-cli
    pkgs.ncat
    pkgs.nix-repl
    pkgs.nodejs
    pkgs.pass
    pkgs.pwgen
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree

    pkgs.nix
  ];

  environment.extraOutputsToInstall = [ "man" ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableSyntaxHighlighting = true;

    variables = {
      # General
      HOME = "/Users/cmacrae";
      GOPATH = "$HOME/code/go";
      GOWORKSPACE = "$HOME/code/go/src/github.com/cmacrae";
      PAGER = "less -R";

      # Nicer manpages
      LESS_TERMCAP_mb = "$'\E[01;31m'";
      LESS_TERMCAP_md = "$'\E[01;31m'";
      LESS_TERMCAP_me = "$'\E[0m'";
      LESS_TERMCAP_se = "$'\E[0m'";
      LESS_TERMCAP_so = "$'\E[01;44;33m'";
      LESS_TERMCAP_ue = "$'\E[0m'";
      LESS_TERMCAP_us = "$'\E[01;32m'";
      
      # History
      HISTSIZE = "1000";
      SAVEHIST = "1000";
      HISTFILE = "~/.history";
    };

    loginShellInit = ''
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

      # Prompts
      if [[ ! -n $INSIDE_EMACS ]]; then
      export "PROMPT=
      %{$fg[blue]%}%m %{$fg[red]%}$ %{$reset_color%}"
      export "RPROMPT=%{$fg[red]%}%~%f%b"
      else
      export "PROMPT=
      %{$fg[blue]%}%~ %{$fg[red]%}$ %f%b"
      fi

      export PATH=${config.environment.systemPath}
      ${config.system.build.setEnvironment}

      # Set EDITOR here after nix calls setEnvironment
      export EDITOR="emacsclient";

      # Aliases
      alias ls="ls -G"
      alias rm="rm -i"
      alias cp="cp -i"
      alias gows="cd $GOWORKSPACE"
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

  # Trackpad tap to click
  system.defaults.trackpad.Clicking = true;

  # Services
  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;

  # Emacs server
  services.emacs.enable = true;

  # Postbuild actions
  environment.postBuild = ''
    HOME=/Users/cmacrae
    KEYFILE="$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
    mkdir -p $HOME/Library/KeyBindings
    test -f $KEYFILE || cat > $KEYFILE <<EOF
    {
      "^ " = setMark:;
      "^/" = undo:;
      "^u" = deleteToBeginningOfParagraph:;
      "^w" = deleteToMark:;
      "^x" = {
        "^x" = swapWithMark:;
        "^m" = selectToMark:;
      };
      "^V" = pageDownAndModifySelection:;
      "~@" = selectWord:;
      "~b" = moveWordBackward:;
      "~c" = (capitalizeWord:, moveForward:, moveForward:);
      "~d" = deleteWordForward:;
      "~f" = moveWordForward:;
      "~l" = (lowercaseWord:, moveForward:, moveForward:);
      "~u" = (uppercaseWord:, moveForward:, moveForward:);
      "~v" = pageUp:;
      "~w" = (deleteToMark:, setMark:, yank:, swapWithMark:);
      "~B" = moveWordBackwardAndModifySelection:;
      "~F" = moveWordForwardAndModifySelection:;
      "~V" = pageUpAndModifySelection:;
    }
    EOF
  '';
}
