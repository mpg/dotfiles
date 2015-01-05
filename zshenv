# ~/.zshenv
# sourced by zsh for every single shell
#
# /!\ MUST be sourceable by plain /bin/sh too! and with set -u too!
# In addition to interactive shells, will be used by:
# - cron jobs that need my usual environnement
# - xprofile on boxes that run X
#
# /!\ should be idempotent!
# can't use guards for that since PATH is reset by login shells (eg in tmux)

# PATH adjustments
path_prepend() {
    test -d "$1" || return

    PATH=$( printf "$PATH" | tr ':' '\n' | grep -v -F "$1" | tr '\n' ':' )
    PATH="$1:${PATH%:}"
}
path_postpend() {
    test -d "$1" || return

    PATH=$( printf "$PATH" | tr ':' '\n' | grep -v -F "$1" | tr '\n' ':' )
    PATH="${PATH%:}:$1"
}
test -d "/usr/local/Cellar" && path_prepend "/usr/local/bin"
#path_prepend "/usr/local/Cellar/ccache/3.2/libexec"
path_prepend "/usr/lib/ccache/bin"
path_prepend "$HOME/usr/texlive/2014/bin/x86_64-linux"
path_prepend "$HOME/usr/gcc-arm-none-eabi-4_9-2014q4/bin"
path_prepend "$HOME/bin"
export PATH

# locale: default, overriden in zshrc for interctive shells
LANG="fr_FR.UTF-8"
LC_COLLATE="C"
export LANG LC_COLLATE

# misc
if which less >/dev/null; then
    PAGER="less"; export PAGER
fi
if which bc >/dev/null; then
    BC_ENV_ARGS="-l -q"; export BC_ENV_ARGS
fi
if which vim >/dev/null; then
    EDITOR="vim"
else
    EDITOR="vi"
fi
export EDITOR

# For PolarSSL's compat.sh
if which gnutls-cli >/dev/null; then
    GNUTLS_CLI=gnutls-cli
    GNUTLS_SERV=gnutls-serv
    export GNUTLS_CLI GNUTLS_SERV
fi

# TeX Live development
if [ -d "$HOME/tl" ]; then
    TEXLIVE="$HOME/tl"
    TLROOT="$TEXLIVE/trunk/Master"
    CTAN="$TEXLIVE/ctan"
    TEX_CATALOGUE="$TEXLIVE/catalogue/entries"
    path_postpend "$TLROOT/tlpkg/bin"
    PERL5LIB="$TLROOT/tlpkg"
    export TEXLIVE TLROOT CTAN TEX_CATALOGUE PERL5LIB
fi

# texdoc dev
if [ -d "$HOME/texdoc/tl-checkout" ]; then
    TEXDOCDEV="$HOME/texdoc/tl-checkout"
    export TEXDOCDEV
fi

