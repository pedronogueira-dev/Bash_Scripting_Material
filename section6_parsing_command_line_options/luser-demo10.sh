#!/bin/bash

# Create a log function to
# echo on to the screen specific text

# log() {
#     echo 'You called the log function!';
# }

# Log function that echoes STDIN to the screen
# function log {
#     local MESSAGE="${@}"
#     echo "${MESSAGE}";
# }

# log 'Hello'
# log 'This' 'has' 'more argument'

# Log function that only echoes STDIN to
# the screen if VERBOSE GLOBAL VAR IS DEFINED

# log() {
#     local VERBOSE="${1}"
#     shift
#     local MESSAGE="${@}"
#     if [[ "${VERBOSE}" = 'true' ]]
#     then
#         echo "${MESSAGE}"
#     fi
# }
# PRINT=true
# log 'VERBOSE is not set'
# log ${PRINT} 'Verbose' 'was' 'set'

# GLOBAL VARIABLES AND PROBLEMS
# Example of problems from Global 
# variable redefinition from a function

# log() {
#     local MESSAGE="${@}"
#     if [[ "${VERBOSE}" = 'true' ]]
#     then
#         echo "${MESSAGE}"
#     fi
#     VERBOSE=false
# }

# readonly VERBOSE=true
# log 'Hello'
# log 'Example'

# Log function that only echoes STDIN to
# the screen if VERBOSE GLOBAL VAR IS DEFINED
# but always logs into unix's syslog

log() {
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${MESSAGE}"
    fi
    logger -t luser-demo10.log "${MESSAGE}"
}

log 'VERBOSE is not set'
readonly VERBOSE=true
log 'Verbose' 'was' 'set'

# Function to backup files

backup_file(){
    # This function creates a backup of a file.
    # Returns non-zero status on error.
    local FILE="${1}"

    # Tests for file existance
    if [[ -f "${FILE}" ]]
    then
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
        
        log "Backing up ${FILE} to ${BACKUP_FILE}."

        # The exit status of the function will be the exit status
        # of the cp command
        cp -p "${FILE}" "${BACKUP_FILE}"
    else
        # Returns non-zero exit status
        log "ERROR: ${FILE} doesn\'t exist."
        return 1
    fi
}

backup_file '/etc/passwd'

if [[ "${?}" -eq 0 ]]
then
    log 'File backup completed'
else
    log 'File backup failed'
    exit 0
fi