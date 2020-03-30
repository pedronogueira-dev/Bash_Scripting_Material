#!/bin/bash

# Example of getops to provide functions
# with bash command like options

# This Script will generate a random password.
# by providing -l, the length of the password can be specified
# by providing -s, a special character will be added to the password
# by providing -v, verbose mode can be set.

readonly SPECIAL_CHARS='-][<>_/|+$%#!?&)(=@*'
# DEFAULT PASSWORD LENGTH
LENGTH=48


usage() {
    echo "Usage: $(basename ${0}) [-sv] [-l LENGTH]" >&2
    echo 'Generate a random password.'
    echo -e "\t-l LENGTH\t allows the length of the password to be generated. by default 48 characters are used"
    echo -e "\t-v\t\t activates verbose mode"
    echo -e "\t-s\t\t LENGTH\t Adds a special character to the password"
}


PASSWORD=$(date +%s%N | sha512sum | head -c16)
PASSWORD=$(echo "${PASSWORD}${SELECTED_CHAR}" | fold -w1 | shuf | tr -d "\n")

status_message() {
    if [[ "${VERBOSE}" = true ]]
    then
        echo "${@}"
    fi
}

password_generator() {
    status_message 'Generating Password.'
    PASSWORD=$(date +%s%N | sha512sum | head -c ${LENGTH})
    if [[ "${USE_SPECIAL_CHARACTER}" = true ]]
    then
        status_message 'Introducing a Special Character to the Password.'
        SELECTED_CHAR=$(echo "${SPECIAL_CHARS}" | fold -w 1 | shuf | head -c 1)
        PASSWORD=$(echo "${PASSWORD:0:$((LENGTH - 1))}${SELECTED_CHAR}" | fold -w1 | shuf | tr -d "\n")
    fi
    status_message 'Finished Password Generation.'
}

while getopts vl:s OPTION
do
    case ${OPTION} in
        v)
            VERBOSE=true
            echo 'Verbose mode on.'
            ;;
        l)
            LENGTH="${OPTARG}"
            ;;
        s)
            USE_SPECIAL_CHARACTER='true'
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

# INSPECT INDEX OF NOT OPTION ARGUMENTS
# echo "OPTIND: ${OPTIND}"

# Remove the options while leaving the remaining arguments.
# (Assuming options are specified before any other parameters)
shift "$(( OPTIND - 1))"

# echo 'After Shitf'

# exits without generating a password if any argument is
# provided, other than the options
if [[ "${#}" -gt 0 ]]
then
    usage
    exit 1
fi

status_message 'Generating a password.'

password_generator
echo "Password: ${PASSWORD}"