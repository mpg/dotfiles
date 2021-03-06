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
#path_prepend "/usr/lib/ccache/bin"
#path_prepend "/usr/lib/ccache"
path_prepend "/usr/class/cs143/bin"
path_prepend "$HOME/usr/texlive/2016/bin/x86_64-linux"
path_prepend "$HOME/usr/arm-cortexa5-linux-uclibcgnueabihf/bin"
path_prepend "$HOME/usr/gcc-arm-none-eabi-9-2020-q2-update/bin"
path_prepend "$HOME/usr/ARM_Compiler_5.06u3/bin"
path_prepend "$HOME/.gem/ruby/2.1.0/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
export PATH

# locale: I prefer everything in English (esp. error messages)
# Pick en_US.UTF-8 as opposed to POSIX for the sake of UTF-8
# Keep dates in French cause my brain can't get used to MM/DD/YYYY
# Sort things in a standard way.
LANG="en_US.UTF-8"
LC_TIME="fr_FR.UTF-8"
LC_COLLATE="C"
export LANG LC_TIME LC_COLLATE

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

# local additions
if [ -r "$HOME/.zshenv.local" ]; then
    source "$HOME/.zshenv.local"
fi
