#!/bin/bash

page="10.0.17.34/Assignment.html"

press=$(curl -sL "$page" | xmlstarlet select --template --value-of "//table[@id='press']//tr//td" | awk 'NR % 2 == 1')

tempature=$(curl -sL "$page" | xmlstarlet select --template --value-of "//table[@id='temp']//tr//td" | awk 'NR % 2 == 1')

dat=$(curl -sL "$page" | xmlstarlet select --template --value-of "//table[@id='temp']//tr//td" | awk 'NR % 2 == 0')

count=$(echo "$press" | wc -l)
for (( i=1; i<="${count}"; i++ ))
do
var1=$(echo "$press" | head -n $i | tail -n 1)
var2=$(echo "$tempature" | head -n $i | tail -n 1)
var3=$(echo "$dat" | head -n $i | tail -n 1)
echo "$var1, $var2, $var3"
done
