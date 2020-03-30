#!/bin/bash

# This script generates a list of random passwords.

# A Random number as password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# A password composed of 3 random numbers
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use the Current date/time epoch as a basis for a password
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use the Current date/time epoch as a basis for a password and the nanoseconds of execution of the command
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Use the Current date/time epoch and check_sums it with sha512sum as a basis for a password
PASSWORD=$(date +%s | sha512sum)
echo "${PASSWORD}"

# Use the Current date/time epoch and nanoseconds,
# check_sums it with sha512sum and uses the first 8 char as a basis for a password
PASSWORD=$(date +%s%N | sha512sum | head -c8)
echo "${PASSWORD}"

# Use the Current date/time epoch and nanoseconds,
# Appends a Set or random numbers
# check_sums it with sha512sum and uses the first 8 chars
# Adds a special char
SPECIAL_CHARS='-][<>_\|+$#!?&)('
PASSWORD=$(date +%s%N | sha512sum | head -c8)
SELECTED_CHAR=$(echo "${SPECIAL_CHARS}" | fold -w 1 | shuf | head -c 1)
PASSWORD=$(echo "${PASSWORD}${SELECTED_CHAR}" | fold -w1 | shuf | tr -d "\n")
echo "${PASSWORD}"