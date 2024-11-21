#! /bin/bash

logFile="/var/log/apache2/access.log.1"
iocFile="/home/champuser/CSI-230-01/Week 12/ioc.txt"
logFile2="/var/log/apache2/access.log"
function displayAllLogs(){
	cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

function displayOnlyPages() {
	cat "$logFile" | cut -d ' ' -f 7 | sort -n | uniq -c
}
# function: displayOnlyPages:
# like displayOnlyIPs - but only pages

function histogram(){

	local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
	# This is for debugging, print here to see what it does to continue:
	# echo "$visitsPerDay"

        :> newtemp.txt  # what :> does is in slides
	echo "$visitsPerDay" | while read -r line;
	do
		local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
		local IP=$(echo "$line" | cut -d  " " -f 1)
          
		local newLine="$IP $withoutHours"
		echo "$IP $withoutHours" >> newtemp.txt
	done 
	cat "newtemp.txt" | sort -n | uniq -c
}

function frequentVisitors() {
    histogramResults=$(histogram) # Call the histogram function and capture its output
    for item in "$histogramResults"; do
        numberOfVisitors=$(echo "$item" | cut -d ' ' -f 6) # Get the number of visitors
        if [ $((numberOfVisitors)) -gt 10 ]; then # Check if number of visitors is greater than 10
            echo "$item" # Print the item if condition is met
        fi # Close the if statement
    done # Close the for loop
}

# function: frequentVisitors: 
# Only display the IPs that have more than 10 visits
# You can either call histogram and process the results,
# Or make a whole new function. Do not forget to separate the 
# number and check with a condition whether it is greater than 10
# the output should be almost identical to histogram
# only with daily number of visits that are greater than 10 

# Function to find suspicious visitors
suspiciousVisitors() {
    # Declare an associative array to store unique IP addresses
    declare -A unique_ips

    # Read the IOC entries into an array
    mapfile -t ioc_entries < "$iocFile"

    # Loop through each line in the access log file
    while IFS= read -r line; do

    	# get ip address and requested page
    	ip_address=$(echo "$line" | awk '{print $1}')
    	requested_page=$(echo "$line" | awk '{print $7}')
        # Check if the requested page matches any entry in the IOC
        for ioc in "${ioc_entries[@]}"; do
            if [[ "$requested_page" == "$ioc" ]]; then
			
                # Store the unique IP address
                unique_ips["$ip_address"]=1
                break  # No need to check further if a match is found
            fi
        done
    done < "$logFile2"

    # Print the unique count of IP addresses
    echo "Unique IP addresses: ${#unique_ips[@]}"
    for ip in "${!unique_ips[@]}"; do
   	    echo "$ip"
    done
}

# function: suspiciousVisitors
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with this indicators of attack
# only display the unique count of IP addresses.  
# Hint: there are examples in slides

# Keep in mind that I have selected long way of doing things to 
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.

while :
do
	echo "PLease select an option:"
	echo "[1] Display all Logs"
	echo "[2] Display only IPS"
	echo "[3] Display only pages visited"
	echo "[4] Histogram"
	echo "[5] Display frequent visitors"
	echo "[6] Display suspicious visitors"
	echo "[7] Quit"

	read userInput
	echo ""

	if [[ "$userInput" == "7" ]]; then
		echo "Goodbye"		
		break

	elif [[ "$userInput" == "1" ]]; then
		echo "Displaying all logs:"
		displayAllLogs

	elif [[ "$userInput" == "2" ]]; then
		echo "Displaying only IPS:"
		displayOnlyIPs

	# Display only pages visited
	elif [[ "$userInput" == "3" ]]; then
 		echo "Displaying only pages:"
		displayOnlyPages

	elif [[ "$userInput" == "4" ]]; then
		echo "Histogram:"
		histogram

    # Display frequent visitors
    elif [[ "$userInput" == "5" ]]; then
        echo "Displaying frequent visitors:"
    	frequentVisitors

    # Display suspicious visitors
    elif [[ "$userInput" == "6" ]]; then
    	echo "Displaying suspicious visitors:"
    	suspiciousVisitors
    	
	# Display suspicious visitors
	# Display a message, if an invalid input is given

	else 
		echo "Please enter a valid number 1-7"
	fi
done
