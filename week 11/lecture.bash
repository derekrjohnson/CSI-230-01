#!bin/bash

function pageCount () {
	awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -nr 
}

# pageCount

function countingCurlAccess () {
	grep 'curl/' /var/log/apache2/access.log | awk '{print $1}' | sort | uniq -c | sort -nr 	
}

countingCurlAccess
