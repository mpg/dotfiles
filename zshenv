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
path_prepend "$HOME/usr/uncrustify-0.75.1/bin"
path_prepend "$HOME/usr/groovy-4.0.23/bin"
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

# local rustup install
if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# default user venv
if [ -d "$HOME/usr/user-venv" ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1
    . "$HOME/usr/user-venv/bin/activate"
fi

# local additions
if [ -r "$HOME/.zshenv.local" ]; then
    . "$HOME/.zshenv.local"
fi
