#!/bin/bash

# Script to Add New Users to 'server01' vm
# Usage: add-new-local-user.sh <username> <user_info...>
# Errors derived from the use of this script will now
# Be be redirected to STDERR

# Check Root Access and Host
if [[ "${UID}" -ne 0 || "${HOSTNAME}" -ne 'server01' ]]
then
    echo 'Permission/Hostname invalid.' >&2
    echo "Usage: $(basename ${0}) USERNAME [INFO]..." >&2
    exit 1
fi
# Set Variables
if [[ "${#}" -lt 2 ]]
then
    echo "INVALID INPUT NUMBER" >&2
    exit 1
fi
USER_NAME="${1}"
shift
USER_INFO="${@}"
# Generate Account
echo "Creating user. username: [${USER_NAME}], info: [${USER_INFO}]" > /dev/null
useradd -c "${USER_INFO}" -m ${USER_NAME} &> /dev/null

# VALIDATE ACCOUNT CREATION

# Generate Password
SPECIAL_CHARS='-][<>_/|+$#!?&)('
PASSWORD=$(date +%s%N | sha512sum | head -c16)
SELECTED_CHAR=$(echo "${SPECIAL_CHARS}" | fold -w 1 | shuf | head -c 1)
PASSWORD=$(echo "${PASSWORD}${SELECTED_CHAR}" | fold -w1 | shuf | tr -d "\n")
echo "Attributing Password: [${USER_NAME}]:[${PASSWORD}]" > /dev/null
echo "${PASSWORD}" | passwd --stdin ${USER_NAME} > /dev/null

if [[ "${?}" -ne 0 ]]
then
    echo "Password Setting failed" >&2
    exit 1
fi
# Expire Password
passwd -e ${USER_NAME} &> /dev/null
# Print User Info
echo -e "USERINFO\t[${USER_NAME}:${PASSWORD}:${HOSTNAME}]"
exit 0