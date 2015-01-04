# ~/.zshenv
# executed by zsh for every single shell
# /!\ MUST be sourceable by plain /bin/sh too! and with set -u too!

# prevent this file from being loaded twice
test -n "${ZSHENV_LOADED:-}" && return
ZSHENV_LOADED="y"; export ZSHENV_LOADED

# PATH adjustments
case $(hostname) in
    *-mac) PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin' ;;
esac
path_prepend() { test -d "$1" && PATH="$1:$PATH"; }
path_prepend "/usr/lib/ccache/bin"
path_prepend "$HOME/usr/texlive/2014/bin/x86_64-linux"
#path_prepend "/usr/local/Cellar/ccache/3.2/libexec"
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
    PATH="$PATH:$TLROOT/tlpkg/bin"
    PERL5LIB="$TLROOT/tlpkg"
    export TEXLIVE TLROOT CTAN TEX_CATALOGUE PERL5LIB
fi

# texdoc dev
if [ -d "$HOME/texdoc/tl-checkout" ]; then
    TEXDOCDEV="$HOME/texdoc/tl-checkout"
    export TEXDOCDEV
fi

