#!/bin/bash

# Script to allow a user with root privileges to
# create new user accounts with randomly generated passwords

# Check Root Access and Host
echo "${UID} - ${HOSTNAME}"
if [[ "${UID}" -ne 0 || "${HOSTNAME}" -ne 'server01' ]]
then
    echo "Usage: $(basename ${0}) USERNAME [INFO]..."
    exit 1
fi
# Set Variables
if [[ "${#}" -lt 2 ]]
then
    echo "INVALID INPUT NUMBER"
    exit 1
fi
USER_NAME="${1}"
shift
USER_INFO="${@}"
# Generate Account
echo "Creating user. username: [${USER_NAME}], info: [${USER_INFO}]"
useradd -c "${USER_INFO}" -m ${USER_NAME}

# VALIDATE ACCOUNT CREATION

# Generate Password
SPECIAL_CHARS='-][<>_/|+$#!?&)('
PASSWORD=$(date +%s%N | sha512sum | head -c16)
SELECTED_CHAR=$(echo "${SPECIAL_CHARS}" | fold -w 1 | shuf | head -c 1)
PASSWORD=$(echo "${PASSWORD}${SELECTED_CHAR}" | fold -w1 | shuf | tr -d "\n")
echo "Attributing Password: [${USER_NAME}]:[${PASSWORD}]"
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo "Password Setting failed"
    exit 1
fi
# Expire Password
passwd -e ${USER_NAME}
# Print User Info
echo -e "USERINFO\t[${USER_NAME}:${PASSWORD}:${HOSTNAME}]"
exit 0