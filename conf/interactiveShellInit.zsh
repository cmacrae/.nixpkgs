''
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
%{$fg[blue]%}%n %{$fg[red]%}$ %{$reset_color%}"
    export "RPROMPT=%{$fg[blue]%}%~%f%b"
else
    export "PROMPT=
%{$fg[blue]%}%~ %{$fg[red]%}$ %f%b"
fi
''
