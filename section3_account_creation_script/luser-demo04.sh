#!/bin/bash

# This script creates an account on the local system.
# You'll be prompted for the username and password.
if [[ "$HOSTNAME" != 'server01' ]]
then
    echo 'HOST NOT RECOGNIZED.'
    exit 1
fi
# Request user name.
read -p 'Enter the username to create: ' USER_NAME
# Ask for the real name.
read -p 'Enter the real name of the user: ' COMMENT
# Ask password
read -p 'Enter the password: ' PASSWORD
# Create user.
useradd -c "${COMMENT}" -m ${USER_NAME}
# Set the password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
# Force Password change on first login.
passwd -e ${USER_NAME}