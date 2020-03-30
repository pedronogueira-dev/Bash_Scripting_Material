#!/bin/bash

# Script to lookup above avg failed login attempts (> 10) from a provided log_file
# if any results are found then a .csv will be created containing
# the number, ip and location of those attempts.

LIMIT='10'
TMP_FILE="/tmp/failed_login_analisys"
RES_FILE="failed_login_analisys_res_$(date +%d%m%Y%H%M%N).csv"
if [[ "${#}" -eq 0 ]]
then
    echo 'Error: LogFile required.' >&2
    exit 1
elif [[ ! -e ${1} ]]
then
    echo "Error: Cannot Open ${1}." >&2
    exit 1 
fi

# grep 'Failed' ${1} | awk -F 'port' '{print $1}' | grep -v '[[:alpha:]]$' | awk '{print $NF}' | sort -h | uniq -c | sort -nr > "${TMP_FILE}"
grep 'Failed' ${1} | awk '{print $(NF - 3)}' | sort -h | uniq -c | sort -nr > "${TMP_FILE}"

while read -r NUM_FAILURES IP
do
    if [[ "${NUM_FAILURES}" -gt "${LIMIT}" ]]
    then
        if [[ ! -e "${RES_FILE}" ]]
        then
            echo "CountIP,Location" >  "${RES_FILE}"
        fi
        echo "${NUM_FAILURES},${IP},$(geoiplookup ${IP} | awk -F ',' '{print $2}' )" >>  "${RES_FILE}"
    fi
done < "${TMP_FILE}"

if [[ ! -e "${RES_FILE}" ]]
then
    echo 'No Invalid Access Found.'
else
    echo "Found $(wc -l ${RES_FILE}) suspicious login attempts"
    cat ${RES_FILE}
fi
rm ${TMP_FILE}
exit 0