# ~/.zshrc
# Executed by zsh for all interactive shells

# history and history file settings
HISTFILE=~/.zhistfile
HISTSIZE=200000         # number of events stored internally
SAVEHIST=100000         # number of events saved in the file
setopt append_history   # don't overwrite hitory file
setopt hist_expire_dups_first   # remove duplicate first when history full
setopt hist_find_no_dups        # don't show duplicated events while searching
setopt hist_ignore_dups # avoid duplicating the last event
setopt extended_history # also save command's timestamps
setopt hist_verify      # show history expansion before executing command
setopt histignorespace  # <space>command -> not in history

# vim rulz (see man zshle for bindkey)
bindkey -v              # use vi keybindings for command-line editing
bindkey -v $terminfo[kdch1] vi-delete-char # fix 'del' key

# help (man) in viins mode
bindkey -v $terminfo[kf1] run-help

# reduce delay after hitting <esc> from default 0.4s to 0.1s
export KEYTIMEOUT=1

# make esc-/ without a delay work
vi-search-fix() {
zle vi-cmd-mode
zle .vi-history-search-backward
}
autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix

# make delete commands work over start of insert
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# more "usual" mapping for searching history
bindkey '^R' history-incremental-search-backward

# quickly visit history without having to reach for the arrow keys
bindkey '^P' up-history
bindkey '^N' down-history

# navigation options
setopt auto_cd          # foo/bar = cd foo/bar
setopt auto_pushd       # cd automatically pushes the old pwd
setopt pushd_ignore_dups # don't push duplicates
setopt pushd_minus      # make -1 the last but one dir
setopt chase_links      # force builtin pwd to tell the truth (like /bin/pwd)
setopt no_cdable_vars   # don't try to expand unknown names as variables

# misc options
setopt no_beep          # don't mess up with my music!
setopt interactive_comments # allow coments in interactive shells too
#setopt extended_glob    # activate # ~ ^ in glob patterns
setopt no_correct       # don't try to correct spelling of command
setopt no_correct_all   # don't try to correct spelling of arguments

# load autocompletion features
autoload -U compinit; compinit

# make autocompletion faster
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcache

# zmv is cool
autoload zmv

# vcs info for the prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true
zstyle ':vcs_info:*' formats '%s|%b|%u%c'

# color code by host for the prompt
case $(hostname) in
    dyson|e105273-mac)  host_color=green        ;;
    thue|mordell)       host_color=yellow       ;;
    *)                  host_color=white        ;;
esac

# custom color prompt
setopt prompt_subst
autoload -U colors; colors
PROMPT='%(?..%{$fg[red]%}%?%{$fg[white]%} )\
%{$terminfo[bold]$fg[blue]%}%n%{$terminfo[sgr0]%}@\
%{$terminfo[bold]$fg['$host_color']%}%m%{$terminfo[sgr0]%} \
%{$terminfo[bold]$fg[magenta]%}%~%{$terminfo[sgr0]%} %# '
RPROMPT=' %{$fg[magenta]%}${vcs_info_msg_0_}%{$terminfo[sgr0]%}'
unset host_color

# custom xterm/rxvt title
case $TERM in (xterm*|rxvt*)
    precmd () {
        vcs_info # see above
        print -Pn "\e]0;%n@%m: %~\a"
    }
    preexec () {
        local nl='
'
        print -Pn "\e]0;%n@%m: "
        print -rn "${1%%$nl*}"
        print -n  "\a"
    }
    ;;
esac

# enable color support of ls & friends (see .zaliasrc)
if [ "$TERM" != "dumb" ]; then
    zstyle ':completion:*:default' list-colors ''

    if ls --color=auto >/dev/null 2>&1; then
        alias ls='ls --color=auto --quoting-style=literal'
    else
        export CLICOLOR=1
    fi
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
fi

# environment needed only for interactive shells
if which less >/dev/null; then
    export PAGER="less"
fi

if which bc >/dev/null; then
    export BC_ENV_ARGS="-l -q"
fi

if which vim >/dev/null; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

export GCC_COLORS=yes

# load aliases
if [[ -r ~/.zaliasrc ]]; then
    . ~/.zaliasrc
fi
