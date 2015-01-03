# ~/.zshenv
# executed by zsh for every single shell
# /!\ MUST be sourceable by plain /bin/sh too! and with set -u too!

# prevent this file from being loaded twice
test -n "${ZSHENV_LOADED:-}" && return
ZSHENV_LOADED="y"; export ZSHENV_LOADED

# PATH adjustments
test -d "/usr/lib/ccache/bin" && PATH="/usr/lib/ccache/bin:$PATH"
test -d "$HOME/usr/texlive/2014/bin/x86_64-linux" && PATH="$HOME/usr/texlive/2014/bin/x86_64-linux:$PATH"
test -d "$HOME/usr/gcc-arm-none-eabi-4_8-2014q3/bin" && PATH="$HOME/usr/gcc-arm-none-eabi-4_8-2014q3/bin:$PATH"
test -d "$HOME/bin" && PATH="$HOME/bin:$PATH"
export PATH

# locale
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

