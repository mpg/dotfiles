#!/bin/sh

MYNAME=deploy.sh
README=Readme.md
NVIM=nvim

# absolute path to the checkout
DIR="$HOME/etc"

if cd $DIR && test -x $MYNAME -a -r $README; then :; else
    echo "Please adjust DIR!" 2>&1
    exit 1
fi

link() {
    file=$1
    link=$2

    if [ -L $link ]; then
        echo "$file already linked, skipping"
        return
    fi

    if [ -e $link ]; then
        echo "$file exists, backing up to $PWD/$file.bak"
        mv $link $file.bak
    fi

    ln -s "$DIR/$file" $link
    echo "$file linked"
}

FILES=$(ls | grep -v $MYNAME'\|'$README'\|'$NVIM)

for f in $FILES; do
    link $f $HOME/.$f
done

link $NVIM $HOME/.config/$NVIM

mkdir -p "$HOME"/.cache/vim/undofiles
mkdir -p ~/.local/share/nvim/undo
echo "(n)vim undofiles directories created"
