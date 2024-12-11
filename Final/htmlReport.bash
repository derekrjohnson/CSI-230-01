#!/bin/bash

# Define input and output files
input_file="report.txt"
output_file="/var/www/html/report.html"

# Create the HTML report
{
    echo "<!DOCTYPE html>"
    echo "<html lang='en'>"
    echo "<head>"
    echo "    <meta charset='UTF-8'>"
    echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
    echo "    <title>Access Logs with IOC indicators</title>"
    echo "    <style>"
    echo "        table { width: 100%; border-collapse: collapse; }"
    echo "        th, td { border: 1px solid black; padding: 8px; text-align: left; }"
    echo "        th { background-color: #f2f2f2; }"
    echo "    </style>"
    echo "</head>"
    echo "<body>"
    echo "    <h1>Access Logs with IOC indicators:</h1>"
    echo "    <br>"
    echo "    <table>"
    echo "        <tr>"
    echo "            <th>IP Address</th>"
    echo "            <th>Date/Time</th>"
    echo "            <th>Page Accessed</th>"
    echo "        </tr>"

    # Read the input file and format it into table rows
    while read -r line; do
        ip=$(echo "$line" | cut -d ' ' -f 1)
        datetime=$(echo "$line" | cut -d ' ' -f 2)
        page_accessed=$(echo "$line" | cut -d ' ' -f 3)
        echo "        <tr>"
        echo "            <td>$ip</td>"
        echo "            <td>$datetime</td>"
        echo "            <td>$page_accessed</td>"
        echo "        </tr>"
    done < "$input_file"

    echo "    </table>"
    echo "</body>"
    echo "</html>"
} > "$output_file"

