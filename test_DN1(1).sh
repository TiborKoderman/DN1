#!/bin/bash

esc='\033'
regular=$esc'[0m'
red=$esc'[91m'
green=$esc'[92m'
bold=$esc'[1m'
format="$bold"'  * %-50s'

assert_equal () {
	if [ "$2" = "$1" ]; then
		message="$3\nOK"
	else
	expected=$1
	found=$2
		message="$3\nNAPAKA (prebrano: ${found//$'\n'/'\\n' }, pričakovano: ${expected//$'\n'/'\\n'})"
	fi
	print_message "$message"
}


assert_OK () {
	if [ "$2" = "$1" ]; then
		message="$3\nOK"
	else
		expected=$(echo "$1" | tr "\n" "$")
		found=$(echo "$2" | tr "\n" "$")
		message="$3\nNAPAKA"
	fi
	print_message "$message"
}

print_message () {
	echo -e "$1" >> "$results"
	let test_counter++
	echo "Test $test_counter zaključen".
}

timeout_checker () {
	sleep 12
	echo -e "Program zaključil:\nNAPAKA (prekoračena časovna omejitev 12 s)" >> "$results"
	wrap_up
}

wrap_up () {
	points=0
	while read line; do
		if [ "$line" = "OK" ]; then
		  printf " [  $green$line$regular$bold  ]$regular\n"
		  let points+=1
		elif [ "${line:0:6}" = "NAPAKA" ]; then
		  printf "[ $red${line:0:6}$regular$bold ]$regular${line:6}\n"
		else
		  awk -v text="$line" -v format="$format" 'BEGIN {printf(format, text)}'
		fi
	done < "$results"
	echo "Skupaj uspešnih testov: $points"
    
    test_counter=0
	if [ $# -gt 0 ] && [ $1 = clean ]; then
          cleanup_process_subtree
	  kill -9 -$$ &> /dev/null
	fi
}

cleanup_process_subtree () {
	kill -9 -$pid &> /dev/null
}

prepare () {
	if [ -e "$results" ]; then
		rm "$results"
	fi

	if [ -e "$errlog" ]; then
    	rm "$errlog"
		touch "$errlog"
	fi

	if [ $(pgrep -c "$(basename $1)") -gt 0 ]; then
		pkill -9 $(basename $1)
	fi

}

test_counter=0

testroot="/tmp/OS-DN1"
mkdir -p "$testroot"
resultsroot="$testroot"


####### 1a #######
testedscript="DN1a.sh"
results="$resultsroot/results-1a.log"
errlog="$resultsroot/err-1a.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"

if [[ -e $testedscript ]]; then 
	# Given example
	rm -rf $testroot/1DNa  &>/dev/null

    mkdir -p $testroot/1DNa/testdir
	echo "some content" > $testroot/1DNa/testfile1.txt
	echo "some content" > $testroot/1DNa/testfile2.txt
	mkfifo $testroot/1DNa/testfifo

	output=$("$testedscript" "$testroot"/1DNa 2>&1)  || { test $? -eq 126 && echo "Nimate pravice zagnati skipte." && exit; }
	output=${output% }

    rez=0
    echo "$output" | grep "datoteke: 2" >/dev/null && rez=1    
    assert_OK 1 $rez "Število navadnih datotek."

    rez=0
    echo "$output" | grep "cevovodi: 1" >/dev/null && rez=1    
    assert_OK 1 $rez "Število cevovodov."

    rez=0
    echo "$output" | grep "imeniki: 1" >/dev/null && rez=1    
    assert_OK 1 $rez "Število imenikov."
	wrap_up
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi


####### 1b #######
testedscript="DN1b.sh"
results="$resultsroot/results-1b.log"
errlog="$resultsroot/err-1b.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"

if [[ -e $testedscript ]]; then 
    
    # Test obstoječih uporabnikov 
    users=(student administrator)
    rez=0
    for usr in ${users[@]}; do
       id $usr &>/dev/null || rez=1;
    done
    assert_OK 0 $rez "Predpogoji za test izpolnjeni:"
    test $rez -eq 1 && { wrap_up; echo "Testni uporabniki ne obstajajo. Prepričajte se, da naslednji uporabniki obstajajo na vašem sistemu: (${users[*]}). Za ustrezno nastavitev uporabnikov sledite navodilom na učilnici v dokumentu \"Virtualka v računalniških učilnicah in virtualka doma\"."; exit 1; };
    
    # Test za pravice
    rm -f $testroot/testfile.txt &>/dev/null
    echo "some content" > $testroot/testfile.txt
    chmod 700 $testroot/testfile.txt
          
    users=(root student administrator)
    "$testedscript" "$testroot/testfile.txt" ${users[*]} 2>/dev/null || { test $? -eq 126 && echo "Nimate pravice zagnati skipte." && exit; }
    
    rez=1
    for usr in ${users[@]}; do
        echo $(getfacl $testroot/testfile.txt 2>/dev/null) | grep "user:$usr:r-x" >/dev/null || rez=0
    done
    assert_OK 1 $rez "Pravilne pravice za podane uporabnike."
    
    
    perm=$(stat -c "%a" $testroot/testfile.txt)
    test $rez -eq 1 && test ${perm:2:1} -eq 0 && rez=1 || rez=0
    assert_OK 1 $rez "Nespremenjene pravice za ostale uporabnike."    
    wrap_up 
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi



####### 1c #######
testedscript="DN1c.sh"
results="$resultsroot/results-1c.log"
errlog="$resultsroot/err-1c.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"


if [[ -e $testedscript ]]; then 
        
    # Postavitev 
    rm -rf $testroot/imenik &>/dev/null
    mkdir $testroot/imenik
    echo -e "\n\n\n\nimport torch" > $testroot/imenik/program1.py
    echo -e "           import torch.backends.cudnn as cudnn" > $testroot/imenik/program2.py


    output=$("$testedscript" "$testroot/imenik" "py" "torch" 2>/dev/null | sort) || { test $? -eq 126 && echo "Nimate pravice zagnati skipte." && exit; }

    rez=0
    echo "$output" | grep "program1.py" >/dev/null && rez=1    
    assert_OK 1 $rez "Najden program."

    rez=0
    echo "$output" | grep "/tmp/OS-DN1/imenik/program1.py : 5 : import torch" >/dev/null && rez=1    
    assert_OK 1 $rez "Najden niz v 1. programu."

    expected="/tmp/OS-DN1/imenik/program1.py : 5 : import torch
/tmp/OS-DN1/imenik/program2.py : 1 : import torch.backends.cudnn as cudnn"
    assert_equal "$expected" "${output%'\n'}" "Pravilen izpis"

    
    wrap_up 
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi

####### 1d #######
testedscript="DN1d.sh"
results="$resultsroot/results-1d.log"
errlog="$resultsroot/err-1d.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript (Prosim počakajte...):"
testedscript=./"$testedscript"


if [[ -e $testedscript ]]; then 
        
    output=$("$testedscript" 2>/dev/null) || { test $? -eq 126 && echo "Nimate pravice zagnati skipte." && exit; }

    rez=0
    s1=0; s2=0
    s1=$(du -ms $(eval echo ~student 2>/dev/null) | cut -f1)
    test $s1 -gt 1 && echo "$output" | grep "student" >/dev/null && rez=1    

    s2=$(du -ms $(eval echo ~administrator 2>/dev/null) | cut -f1)
    test $s2 -gt 1 && echo "$output" | grep "administrator" >/dev/null && rez=1
    assert_OK 1 $rez "Več kot 1MB podatkov."

    rez=0
    test $s1 -gt 1 && rez=0 && echo "$output" | grep "${s1}MB student" >/dev/null && rez=1    
    test $s2 -gt 1 && rez=0 && echo "$output" | grep "${s2}MB administrator" >/dev/null && rez=1
    assert_OK 1 $rez "Pravilno izračunano."
   
    wrap_up 
    { [ $s1 -gt 1 ] || [ $s2 -gt 1 ]; } || echo -e "\nZagotovite da ima student ali administrator več kot 1MB podatkov.\n"
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi


####### 1e #######
testedscript="DN1e.sh"
results="$resultsroot/results-1e.log"
errlog="$resultsroot/err-1e.log"
prepare "$testedscript"

echo "-----------------------------"
echo "Testi za nalogo $testedscript:"
testedscript=./"$testedscript"


if [[ -e $testedscript ]]; then 

   # Postavitev 
   rm -rf $testroot/imenik1 &>/dev/null
   rm -rf $testroot/imenik2 &>/dev/null
   mkdir $testroot/imenik1
   mkdir $testroot/imenik2

   echo -e "test" > $testroot/imenik1/dat.txt
   echo -e "test2" > $testroot/imenik1/dat2.txt

   output=$("$testedscript" "$testroot/imenik1" "$testroot/imenik2" 2>/dev/null) || { test $? -eq 126 && echo "Nimate pravice zagnati skipte." && exit; }
   output1="$(ls $testroot/imenik1)"
   output2="$(ls $testroot/imenik2)"

   rez=0 
   test "$output1" = "$output2" && rez=1

   expected="Uspešno kopirani 2 datoteki."
   assert_equal "$expected" "${output%'\n'}" "Pravilen 1. izpis."    
   assert_OK 1 $rez "Uspešno kopiranje."
   
   output=$("$testedscript" "$testroot/imenik1" "$testroot/imenik2" 2>/dev/null) 
   expected="Ni novih datotek."
   assert_equal "$expected" "${output%'\n'}" "Pravilen 2. izpis."    

   echo -e "test" > $testroot/imenik1/dat3.txt
   output=$("$testedscript" "$testroot/imenik1"  "$testroot/imenik2"  2>/dev/null) 
   expected="Uspešno kopirana 1 datoteka."
   assert_equal "$expected" "${output%'\n'}" "Pravilen 3. izpis."    


    wrap_up
else 
	echo "Skripte $testedscript ni v trenutnem imeniku ali pa še ne obstaja." 
fi


exit 0
