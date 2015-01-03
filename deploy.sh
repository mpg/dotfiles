#!/bin/sh

MYNAME=deploy.sh
README=Readme.md

# location of the checkout, relative to HOME
DIR=etc

if cd $HOME/$DIR && test -x $MYNAME -a -r $README; then :; else
    echo "Please adjust DIR!" 2>&1
    exit 1
fi

link() {
    file=$1
    link=$HOME/.$1

    if [ -L $link ]; then
        echo "$file already linked, skipping"
        return
    fi

    if [ -e $link ]; then
        echo "$file exists, backing up to $file.bak"
        mv $link $file.bak
    fi

    ln -s "$DIR/$file" $link
    echo "$file linked"
}

FILES=$(ls | grep -v $MYNAME'\|'$README)

for f in $FILES; do
    link $f
done
