#!/bin/bash
#
#   This Script runs a given command on every server from a list of servers
#   run-everywhere.sh [OPTION...] <args>
#
#****************************************************************************
#   GLOBAL VARS
SERVER_FILE='/vagrant/servers'
SSH_COMMAND='ssh -o ConnectTimeout=2'
DRY_RUN=false
SUPER_USER=""
VERBOSE=false
EXIT_STATUS='0'
#****************************************************************************
#   FUNCTIONS

usage() {
    echo 'run-everywhere.sh [OPTION...] <args>'
    echo 'OPTIONS:'
    echo -e '-f <FILE>\t\t Replaces FILE as the source of servers where to execute the command on.'
    echo -e '-n\t\t Enables Dry-Run mode.'
    echo -e '-s\t\t Executes Commands as super user.'
    echo -e '-v\t\t Enables Verbose mode.'
}

verbose_message() {
    if [[ "${VERBOSE_MODE}" -eq true ]]
    then
        echo "${@}" >&1
    fi
}
#***************************************************************************
# BODY
if [[ "${UID}" -ne 1000 ]]
then
    echo "ERROR: Permission denied. $(basename) requires root access." >&2
    exit 1
fi

while getopts f:nsv OPTION
do
    case ${OPTION} in
        f) 
            SERVER_FILE=${OPTARG} ;;
        n)  DRY_RUN=true ;;
        s)  SUPER_USER="sudo" ;;
        v)  VERBOSE=true ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

shift "$((OPTIND - 1))"

if [[ "${#}" -eq 0 ]]
then
    echo "Error: No commands provided." >&2
    usage
    exit 1
fi

if [[ ! -e "${SERVER_FILE}" ]]
then
    echo "ERROR: Cannot open ${SERVER_FILE}." >&2
    exit 1
fi

verbose_message "Processing Servers on ${SERVER_FILE}"
COMMAND="${@}"

for SERVER in $(cat ${SERVER_FILE})
do
    verbose_message "Running command ${COMMAND} on server ${SERVER}"
    REMOTE_COMMAND="${SSH_COMMAND} ${SERVER} ${SUPER_USER} ${COMMAND}"
    if [[ "${DRY_RUN}" = true ]]
    then
        echo "DRY RUN: ${REMOTE_COMMAND}" >&1
    else
        verbose_message "Attempting: ${REMOTE_COMMAND}."
        ${REMOTE_COMMAND} 1> verbose_message
        REMOTE_EXECUTION_STATUS="${?}"
    fi

    if [[ "${REMOTE_EXECUTION_STATUS}" -eq 255 ]]
    then
        echo "ERROR: Unable to connect to ${SERVER}" >&2
    elif [[ "${REMOTE_EXECUTION_STATUS}" -ne 0 ]]
    then
        EXIT_STATUS="${REMOTE_EXECUTION_STATUS}"
        echo "ERROR: Unable to run: '${SUDO_U}${COMMAND}' on ${SERVER}" >&2
    else
        verbose_message "Success."
    fi
done

verbose_message "Done"
exit ${EXIT_STATUS}