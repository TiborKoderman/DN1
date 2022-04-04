#!/bin/bash

#echo "$(grep $1 -R --include \*.$2 -e $3 -n )";
#echo ${(grep $1 -R --include \*.$2 -e $3 -n)//":"/" : "}
#temp=$(printf "%s\n" `grep $1 -R --include \*.$2 -e $3 -n`)
#temp = ${temp | sed G}
#echo "$(grep $1 -R --include \*.$2 -e $3 -n)"

#echo -e ${temp//:/ : }
temp="`grep $1 -R --include \*.$2 -e $3 -n`"
#temp=${temp//"n /"/"n"}
temp=${temp//":"/" : "}
#temp=${temp//"n "/"n"}
echo "$temp"
#printf $temp