# ~/.zshenv
# sourced by zsh for every single shell
#
# /!\ MUST be sourceable by plain /bin/sh too! and with set -eu too!
# In addition to interactive shells, will be used by:
# - cron jobs that need my usual environnement
# - xinit on boxes that run X
#
# /!\ should be idempotent!
# can't use guards for that since PATH is reset by login shells (eg in tmux)

# PATH adjustments
path_prepend() {
    if [ -d "$1" ]; then
        PATH=$( printf "$PATH" | tr ':' '\n' | grep -v -F "$1" | tr '\n' ':' )
        PATH="$1:${PATH%:}"
    fi
}
path_postpend() {
    if [ -d "$1" ]; then
        PATH=$( printf "$PATH" | tr ':' '\n' | grep -v -F "$1" | tr '\n' ':' )
        PATH="${PATH%:}:$1"
    fi
}
path_prepend "/usr/lib/ccache"
path_prepend "$HOME/usr/arm-cortexa5-linux-uclibcgnueabihf/bin"
path_prepend "$HOME/usr/gcc-arm-none-eabi-9-2020-q2-update/bin"
path_prepend "$HOME/usr/ARM_Compiler_5.06u3/bin"
path_prepend "$HOME/usr/uncrustify-0.75.1/bin"
path_prepend "$HOME/.gem/ruby/2.1.0/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
export PATH

# locale: I prefer everything in English (esp. error messages)
# Pick en_GB.UTF-8 as opposed to POSIX for the sake of UTF-8
# Pick GB rather than US for the sake of dates
# Sort things in a standard way.
LANGUAGE=en
LANG="en_GB.UTF-8"
LC_COLLATE="C"
export LANGUAGE LANG LC_COLLATE

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

# local rustup install
if [ -r "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# local additions
if [ -r "$HOME/.zshenv.local" ]; then
    source "$HOME/.zshenv.local"
fi
