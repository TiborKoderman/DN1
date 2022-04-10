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

# x=$(sudo ls -d /home/* | xargs du -sh -BM --apparent-size -t1M | sort -rh)
# x=${x//"/home/"}
# echo ${x//M/MB}

#TUKI IZPISUJEMO MiB ne MB ampak mora pisat MB ???
#V NAVODILU PIŠE MB
#zgubu sm 2 uri ob 2h zjutri na tem
# tmp=$(echo `du -m --max-depth=1 -t1M /home | grep -e'/home/.'| sort -h -r`)
# printf "%sMB %s\n" ${tmp//"/home/"/""}


# Upošteva, če slučajno home directory userja ni v /home mapi
for f in $(cat /etc/passwd | cut -d":" -f1,3,6); do

    user=$(echo $f | cut -d":" -f1)
    uuid=$(echo $f | cut -d":" -f2)
    path=$(echo $f | cut -d":" -f3)

    if [ $uuid -lt 1000 ] || ! [ -d $path ] # -Če želimo popolnoma vse userje lahko tukaj odstranimo prvi pogoj, vendar to upočasni skripto za nekaj sekund
    then
        continue
    fi
    
    velikost=`du -sm -t1M $path 2>/dev/null | cut -f1`

    if [ $velikost ]
    then
        printf "%sMB %s\n" $velikost $user
    fi
done | sort -rh