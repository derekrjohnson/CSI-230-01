#!/bin/bash

# Pull plain ip
ip addr | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d ' '  -f 6 | grep '10.*' | cut -d '/' -f 1
