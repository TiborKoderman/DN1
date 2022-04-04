#!/bin/bash
counter=0
for f in $1
do
    #echo "$1/$f > $2/$f"

    # if [ ! -e "$2/$f" ]
    # then
    #     cp -r "$1/$f" "$2/$f"
    #     ((counter++))
    # elif [[ $(cmp -s "$1/$f" "$2/$f") -eq 0 ]]
    # then
    #     cp -fr "$1/$f" "$2/$f"
    #     ((counter++))
    # fi


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