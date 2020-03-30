#!/bin/bash

# Demonstrate the use of shift and while loops

# Display the firts 3 parameters

echo "Parameter 1: ${1}"
echo "Parameter 2: ${2}"
echo "Parameter 3: ${3}"
echo

while [[ "${@}" ]]
do
    echo "${1}"
    shift
done