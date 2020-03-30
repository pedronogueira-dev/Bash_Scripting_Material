#!/bin/bash

# This script show the open ports on a system
# Use -4 as an argument to limit to tcpv4 ports

if [[ "${#}" -ne 0 && "${1}" -ne '-4' ]]
then
    echo 'Use -4 to limit ports to tcpv4'
    exit 1
fi
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'