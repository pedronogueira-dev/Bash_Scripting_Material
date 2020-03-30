#!/bin/bash

# This Script generates a random password for each user specified on the command line

# Display what the user typed on the command line
echo "You executed this script: ${0}"

# Separate path and filename
echo "Path: $(dirname ${0})"
echo "Filename: $(basename ${0})"

# Tell user how many arguments they passed in
# (Inside the script they are parameters, outside they are arguments)

NUMBER_OR_PARAMETERS="${#}"
echo "You supplied ${NUMBER_OR_PARAMETERS} argument(s) on the command line."

# Check at least one user was provided

if [[ "${NUMBER_OR_PARAMETERS}" -lt 1 ]]
then
    echo "Usage: $(basename ${0}) USER_NAME [USER_NAME]..."
    exit 1
fi

echo -e "User Name\t|\tPassword"
for USER_NAME in "${@}"
do
    SPECIAL_CHARS='-][<>_/|+$#!?&)('
    PASSWORD=$(date +%s%N | sha512sum | head -c16)
    SELECTED_CHAR=$(echo "${SPECIAL_CHARS}" | fold -w 1 | shuf | head -c 1)
    PASSWORD=$(echo "${PASSWORD}${SELECTED_CHAR}" | fold -w1 | shuf | tr -d "\n")
    echo -e "USERNAME: ${USER_NAME}\t|\tPASSWORD: ${PASSWORD}"
done
