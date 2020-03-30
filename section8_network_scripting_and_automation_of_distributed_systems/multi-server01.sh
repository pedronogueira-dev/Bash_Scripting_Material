#!/bin/bash
#
#   This Script pings a list of servers and reports their status.

SERVER_FILE='/vagrant/servers'

if [[ ! -e "${SERVER_FILE}" ]]
then
    echo "ERROR: Cannot open ${SERVER_FILE}"
    exit 1
fi

for SERVER in $(cat ${SERVER_FILE})
do
    echo "Pinging ${SERVER}"
    ping -c 3 ${SERVER} &> /dev/null
    if [[ "${?}" -ne 0 ]]
    then 
        echo "${SERVER} is down."
    else
        echo "${SERVER} is up."
    fi
done

exit 0