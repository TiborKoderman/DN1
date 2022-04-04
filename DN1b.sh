#!/bin/bash

for n in ${*:2}; do # iterira od drugega argumenta naprej
    setfacl -m u:$n:rx $1
    #getfacl za najdit rešitve
done