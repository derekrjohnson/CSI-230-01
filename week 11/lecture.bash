#!bin/bash

function pageCount () {
	awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -nr 
}

pageCount
