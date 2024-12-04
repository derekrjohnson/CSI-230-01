#!/bin/bash

# Log the access to the fileaccesslog.txt
echo "$(date) userLogs.bash was accessed" >> "/home/champuser/CSI-230-01/Week-14/fileaccesslog.txt"

# Define email parameters
subject="File Access Log"
body=$(<"/home/champuser/CSI-230-01/Week-14/fileaccesslog.txt")  # Read the contents of fileaccesslog.txt

# Construct the email message without using ":" directly
email_message=$(printf "Subject %s\nTo %s\n\n%s" "$subject" "$recipient" "$body")

# Send the email using ssmtp
echo -e "$email_message" | ssmtp "derek.johnson01@mymail.champlain.edu"
