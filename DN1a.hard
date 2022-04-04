#!/bin/bash
#echo "datoteke: $(find $1 -type f | wc -l)"
echo "datoteke: $(ls $1 -l | grep ^- | wc -l)"

#echo "skrite: $(find $1 -type f -regex '^.+/\.[^\.].+' | wc -l)"
echo "skrite: $(ls -A | grep "^\." | wc -l)"
#veliki a je almost all, je brez . in ..

#echo "mehke povezave: $(find $1 -type l | wc -l)"
echo "mehke povezave: $(ls $1 -l | grep ^l | wc -l)"

#echo "trde: $(ls -l | cut -d' ' -f2- )"
#echo "trde povezave: $(ls -l | cut -d" " -f2)"
echo "trde pocezave: $(ls -l | awk '{if ($2 > 1) print $2}' | wc -l)"


#echo "cevovodi: $(find $1 -type p | wc -l)"
echo "cevovodi: $(ls $l -l | grep ^p | wc -l)"

#echo "imenki: $(find $1 -type d | wc -l)"
echo "imeniki: $(ls $1 -l | grep ^d | wc -l)"










#echo "me"



#echo "skrite: $(ls -dl '.[^.]+' $1)"