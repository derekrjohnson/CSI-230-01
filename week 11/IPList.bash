#!/bin/bash

# List all the ips in the given network prefix

# Usage: bash IPList.bash 10.0.17
if [ $# -ne 1 ] 
	then echo "Usage: $0 <prefix>"
	exit 1
fi

# take prefix
prefix=$1

# verify input length
[ ${#prefix} -le 5 ] && \
printf "Prefix length is too short\nPrefix example: 10.0.17\n" && \
exit 1

for i in {1..20}
do 
	ping -c 1 "$prefix.$i" | grep "64 bytes from" | \
	cut -d ' ' -f 4 | cut -d ':' -f 1
done
