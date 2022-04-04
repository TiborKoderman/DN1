#!/bin/bash

# str=""
# for uporabnik in $(cut -d: -f1 /etc/passwd); do
#     if [ -d /home/$uporabnik ]; then
#        str="$str$(du -hs -BMB -t1MB /home/$uporabnik)\n"
#        #echo ${tmp//"/home/"/""}
#     fi
# done
# echo `cat $str | sort -h -r`

#opcija preglej /etc/passwd
# str=""
# for dir in $(cut -d: -f6 /etc/passwd); do
#         str="$str$(du -sh -BMB -t1MB $dir)\n"
# done

# echo $str


#tmp=$(printf "%s %s\n" `du -h --max-depth=1 -BMiB -t1M /home | grep -e'/home/.'| sort -h -r`)
#tmp=${tmp//"MiB"/"MB"}

#TUKI IZPISUJEMO MiB ne MB ampak mora pisat MB ??!?!?!?!?!?!??!?!?! reeeeeee
#V NAVODILU PIŠE MB
#zgubu sm 2 uri ob 2h zjutri na tem
tmp=$(printf "%sMB %s\n" `du -m --max-depth=1 -t1M /home | grep -e'/home/.'| sort -h -r`)
printf "%s %s\n" ${tmp//"/home/"/""}