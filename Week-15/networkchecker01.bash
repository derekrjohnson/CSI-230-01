#!/bin/bash

myIP=$(bash myIP.bash)

# Todo-1: Create a helpmenu function that prints help for the script
function helpMenu() {
  echo "Help Menu"
  echo "---------------"
  echo "-n: Add -n as an argument for this script to use nmap "
  echo "-n external: External NMAP scan"
  echo "-n internal: Internal NMAP scan"
  echo "-s: Add -s as an argument for this script to use ss"
  echo "-s external: External ss(Netstat) scan"
  echo "-s internal: Internal ss(Netstat) scan"
  echo ""
  echo "Usage: sudo bash networkchecker.bash -n/-s external/internal"
  echo "---------------"
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "External Nmap Results:"
  echo "$rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "Internal Nmap Results:"
  echo "$rin"
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){
  ssPorts=$(ss -tulpn | grep '0.0.0.0:' | awk '{split($5, a, ":"); split($7, b, ","); print a[2], b[1]}' | sed 's/users:(("//; s/",.*//; s/"//')
  echo "External Listening Ports:"
  echo "$ssPorts"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
  ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
  echo "Internal Listening Ports:"
  echo "$ilpo"
}

# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ "$#" -ne 2 ]; then
  helpMenu
  exit 1
fi

# Todo-4: Use getopts to accept options -n and -s
while getopts ":n:s:" opt; do
  case $opt in
    n)
      if [[ "$OPTARG" == "external" ]]; then
        ExternalNmap
      elif [[ "$OPTARG" == "internal" ]]; then
        InternalNmap
      else
        helpMenu
        exit 1
      fi
      ;;
    s)
      if [[ "$OPTARG" == "external" ]]; then
        ExternalListeningPorts
      elif [[ "$OPTARG" == "internal" ]]; then
        InternalListeningPorts
      else
        helpMenu
        exit 1
      fi
      ;;
    \?)
      helpMenu
      exit 1
      ;;
  esac
done
