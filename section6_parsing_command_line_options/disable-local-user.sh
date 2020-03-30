#!/bin/bash

# Script to automate user account disabling,
# deleting and optionally, archiving on /archiving

# Constants
DELETE_ACCOUNT=false
REMOVE_HOME_DIR=false
ARCHIVE_HOME_DIR=false
VERBOSE=false
# Functions
usage() {
    SCRIPT_NAME="$(basename ${0})"
    echo "${SCRIPT_NAME} [OPTION...] <username>"
    echo "${SCRIPT_NAME} disables a user account.\
    This behaviour may be altered by providing an option flag."
    echo "OPTIONS:"
    echo -e "-d\t\tDeletes the provided user account instead of disabling it."
    echo -e "-r\t\tRemoves the home directory associated with the account."
    echo -e "-a\t\tArchives a copy of the user account on '/archiving'"
    echo -e "-v\t\tEnables Verbose Mode"
}

verbal_mode_message() {
    MESSAGE="${@}"
    if [[ "${VERBOSE}" == true ]]
    then
        echo ${MESSAGE}
    fi
    return 0
}

disable_account() {
    USERNAME=${1}

    verbal_mode_message "Disabling: ${USERNAME}"

    chage -E 0 ${USERNAME}
    if [[ "${?}" -ne 0 ]]
    then
        echo "Error: Unable to disable account [${USERNAME}]" >&2
        return 1
    fi
    return 0
}

delete_account() {
    USERNAME=${1}

    verbal_mode_message "Deleting: ${USERNAME}"

    # if [[ ${REMOVE_HOME_DIR} == true ]]
    # then
    #     userdel -r ${USERNAME}
    # else
        userdel ${USERNAME}
    # fi

    if [[ "${?}" -ne 0 ]]
    then
        echo "Error: Unable to delete account [${USERNAME}]" >&2
        return 1 
    fi
    return 0
}

archive_home_dir() {
    USERNAME=${1}
    DESTINATION="/archives"
    FILE_NAME="${USERNAME}_$(date +%d%m%Y%H%M%N)"

    if [[ ! -d "${DESTINATION}" ]]
    then
        verbal_mode_message "Creating: ${DESTINATION}"
        mkdir "${DESTINATION}"
    fi

    verbal_mode_message "Archiving Home Directory for: ${USERNAME}"
    tar -zcvf "${FILE_NAME}.tar.gz" "/home/${USERNAME}" &>/dev/null

    if [[ "${?}" -ne 0 ]]
    then
        echo "Error: Unable to archive directory of the account [${USERNAME}]." >&2
        return 1
    fi

    # tar -ztvf compressed_file <- lists contents

    verbal_mode_message "Moving ${FILE_NAME} Home Directory to ${DESTINATION}"
    mv "${FILE_NAME}.tar.gz" "${DESTINATION}"

    if [[ "${?}" -ne 0 ]]
    then
        echo "Error: Unable to move archive to ${DESTINATION}." >&2
        return 1
    fi
    return 0
}

remove_home_directory() {
    USERNAME=${1}

    verbal_mode_message "Removing ${USERNAME} Home Directory."
    rm -rf "/home/${USERNAME}"
    if [[ "${?}" -ne 0 ]]
    then
        echo "Error: Unable to remove home directory of ${USERNAME}." >&2
        return 1
    fi
    return 0
}

disable_local_user_main() {
    ACCOUNT_NAME=${1}
    USER_UID=$(id -u ${ACCOUNT_NAME} 2>/dev/null)

    verbal_mode_message "Processing ${ACCOUNT_NAME}."

    if [[ "${?}" -ne 0 ]]
    then
        echo "ERROR: argument isn't an account."
        return 1
    fi

    # check if account uid >= 1000
    if [[ "${USER_UID}" -lt 1001 ]]
    then
        echo "ERROR: can't disable or cancel account."
        return 1
    fi

    if [[ "${ARCHIVE_HOME_DIR}" = true ]]
    then
        archive_home_dir ${ACCOUNT_NAME}
        if [[ "${?}" -ne 0 ]]
        then
            return 1
        fi

        echo "Copied and Archieved Home Directory for ${ACCOUNT_NAME}"
    fi

    if [[ "${REMOVE_HOME_DIR}" = true ]]
    then
        remove_home_directory ${ACCOUNT_NAME}
        if [[ "${?}" -ne 0 ]]
        then
            return 1
        fi
        echo "Removed Home Directory for ${ACCOUNT_NAME}"
    fi


    if [[ "${DELETE_ACCOUNT}" = true ]]
    then
        delete_account ${ACCOUNT_NAME}
        echo "Deleted Account [${ACCOUNT_NAME}]"
    else
        disable_account ${ACCOUNT_NAME}
        echo "Disabled Account [${ACCOUNT_NAME}]"
    fi

    if [[ "${?}" -ne 0 ]]
    then
        return 1
    fi

    return 0
}

# Verfiy root permissions| hostname
if [[ "${UID}" -ne 0 || "${HOSTNAME}" != 'server01' ]]
then
    echo 'Error: This script can only be run on test1 with root permission.' >&2
    exit 1
fi
# Process options
while getopts drav OPTION
do
    case ${OPTION} in
        d)
            DELETE_ACCOUNT=true
            ;;
        r)
            REMOVE_HOME_DIR=true
            ;;
        a)
            ARCHIVE_HOME_DIR=true
            ;;
        v)
            VERBOSE=true
            ;;
        ?)
            echo 'Error: Unkown Option.'
            usage
            exit 1
            ;;
    esac
done
# Trim input

shift $((OPTIND - 1))


if [[ "${#}" -eq 0 ]]
then
    usage
fi

for ARG in $@
do
    disable_local_user_main ${ARG}
    if [[ "${?}" -ne 0 ]]
    then
        exit 1
    fi
    shift

    if [[ "${#}" -gt 0 ]]
    then
        echo
    fi
done
# check if param is an account

echo 'Done.'
exit 0