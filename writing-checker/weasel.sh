#!/usr/bin/env bash

# Credit to https://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/
 
weasels="many|various|very|fairly|several|extremely\
|exceedingly|quite|remarkably|few|surprisingly\
|mostly|largely|huge|tiny|((are|is) a number)\
|excellent|interestingly|significantly\
|substantially|clearly|vast|relatively|completely"
 
wordfile=""
 
# Check for an alternate weasel file
if [ -f $HOME/etc/words/weasels ]; then
    wordfile="$HOME/etc/words/weasels"
fi
 
if [ -f $WORDSDIR/weasels ]; then
    wordfile="$WORDSDIR/weasels"
fi
 
if [ -f words/weasels ]; then
    wordfile="words/weasels"
fi
 
if [ ! "$wordfile" = "" ]; then
    weasels="xyzabc123";
    for w in `cat $wordfile`; do
        weasels="$weasels|$w"
    done
fi
 
 
if [ "$1" = "" ]; then
    echo "usage: `basename $0` <file> ..."
    exit
fi
 
egrep -i -n --color "\\b($weasels)\\b" $*

exit 0
