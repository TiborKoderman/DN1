#!/bin/bash
counter=0
#echo "$1"
for t in $1/*
do
    f=$(basename "$t" suffix)
    #echo "$2/$f"
    #echo $f
    if [ ! -e "$2/$f" ]
    then
        #echo "$1/$f > $2/$f"
        cp -rf "$1/$f" "$2/$f"
        ((counter++))
    elif [ $(cmp -s "$1/$f" "$2/$f"; echo $?) -ne 0 ]
    #elif [ $(diff -qr "$1/$f" "$2/$f") != ""]
    then
        #echo "$1/$f > $2/$f"
        cp -fr "$1/$f" "$2/$f"
        ((counter++))
    fi

done

if [ $counter -eq 0 ]
then
    echo "Ni novih datotek."
elif [ $counter -eq 1 ]
then
    echo "Uspešno kopirana $counter datoteka."
elif [ $counter -eq 2 ]
then
    echo "Uspešno kopirani $counter datoteki."
else
    echo "Uspešno kopiranih $counter datotek."
fi