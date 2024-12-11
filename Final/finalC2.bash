#!/bin/bash

# Initialize the iocRequests variable
iocRequests=""

# Read each IOC from ioc.txt
while IFS= read -r ioc; do
  # Append the matching requests to iocRequests
  iocRequests+=$(grep "$ioc" /var/log/apache2/access.log)
done < IOC.txt

# Output the iocRequests variable
echo "$iocRequests" | cut -d ' ' -f1,4,7 | sed 's/\[//g' > report.txt
