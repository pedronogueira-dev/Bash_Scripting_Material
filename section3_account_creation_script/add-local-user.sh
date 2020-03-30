#!/bin/bash

# Check if host machine is server01
# Check Super User Permission to run file
VALID_HOST='server01'
if [[ "${UID}" -ne 0 ]]
then
    echo "ERROR: SUPER USER PERMISSION REQUIRED TO RUN THIS FILE"
    exit 1
elif [[ "${HOSTNAME}" != "${VALID_HOST}" ]]
then
    echo "ERROR: INVALID HOSTNAME"
    exit 1
fi

# Prompt For UserName
while [[ -z $USER_NAME ]] 
do
    read -p 'Enter username to register: ' USER_NAME
done
# Prompt For User_Name_Info
while [[ -z $USER_INFO ]]
do
    read -p 'Enter name of User: ' USER_INFO
done
# Prompt For USER_TMP_PASS
while [[ -z $USER_PASS ]]
do
    read -p 'Enter password: ' USER_PASS
done
# CREATE USER -> -c (INFO/COMMENT) -m (HANDLE/USERNAME)
useradd -c "${USER_INFO}" -m ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo "Account Creation failed"
    exit 1
fi
# DEFINE TEMPORARY PASSWORD
echo "${USER_PASS}" | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo "Password Setting failed"
    exit 1
fi

passwd -e ${USER_NAME}

# ECHOES USERNAME, PASS and HOST
echo "created user: [username|password|host]:"
echo "\t[${USER_NAME}|${USER_PASS}|${HOSTNAME}]:"
exit 0


# userdel username to remove