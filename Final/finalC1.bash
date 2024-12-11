#!/bin/bash

# IOCs extracted to IOC.txt
curl -s "10.0.17.6/IOC.html" | grep -oP '(?<=<td>).*?(?=</td>)' | awk 'NR % 2 == 1' > IOC.txt
