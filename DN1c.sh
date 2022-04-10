#!/bin/bash

#echo "$(grep $1 -R --include \*.$2 -e $3 -n )";
#echo ${(grep $1 -R --include \*.$2 -e $3 -n)//":"/" : "}
#temp=$(printf "%s\n" `grep $1 -R --include \*.$2 -e $3 -n`)
#temp = ${temp | sed G}
#echo "$(grep $1 -R --include \*.$2 -e $3 -n)"

# temp="`grep $1 -R --include \*.$2 -e $3 -n | awk '{$1=$1};1'`"

# echo "$temp"

#printf "D%s\n" $temp
#awk '{$temp=$temp;print}'
#temp=${temp//":"/" : "}
#echo "$temp"

while read -r line
do
    echo ${line//":"/" : "}
done <<< `grep $1 -R --include \*.$2 -e $3 -n`

#temp="/tmp/OS-DN1/imenik/program1.py:5:import torch\n/tmp/OS-DN1/imenik/program2.py:1:import torch.backends.cudnn as cudnn"

# while read line
# do
# printf "%s : %s : %s\n" "$(echo "$line" | cut -d":" -f 1)" "$(echo "$line" | cut -d":" -f 2)" "$(echo "$line" | cut -d":" -f 3)"

# done <<< "$temp"

#printf "%s %s %s\n" $temp


#temp=${temp//"\n /"/"\n/"}
#temp=${temp//"n "/"n"}
#printf $temp