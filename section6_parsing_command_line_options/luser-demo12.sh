#!/bin/bash

# Script to deletes a user accounts

usage() {
    echo "$(basename ${0}) username"
    echo " Deletes the user account for the provided username"
}


# Run as root

if [[ "${UID}" -ne 0 ]]
then
    echo 'Permission denied. root permission required.'
    exit 1
fi

# Validates username was provided
if [[ "${#}" -lt 1 ]]
then
    usage
    exit 1
fi


# Assume the first argument is the user to delete.
USER_NAME="${1}"

# Validates that given user exists and isnt a reserved account
ACCOUNT_UID=$(id -u "${USER_NAME}" 2>/dev/null)
if [[ "${?}" -ne 0 ]]
then
    echo 'username provided does not correspond to an account.'
    exit 1
elif [[ "${ACCOUNT_UID}" -lt 1001 ]]
then
    echo 'username provided cannot be deleted.'
    exit 1
fi

# Delete user
userdel ${USER_NAME}

# Confirm is user was deleted
if [[ "${?}" -ne 0 ]]
then
    echo "The account ${USER_NAME} was not deleted." >&2
    exit 1
fi

# Confirm deletion

echo "user account ${USER_NAME} was deleted successfully"
exit 0