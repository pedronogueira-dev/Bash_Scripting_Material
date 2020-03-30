#!/bin/bash

# Display the UID and username of the user
# Display if vragant or not

# Display UID
echo "UID => ${UID}"

# ONLY display if the UID does NOT match 1000.
UID_TO_TEST_FOR='1000'

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
    echo "UID DOES NOT MATCH ${UID_TO_TEST_FOR}"
    exit 1
fi

USER_NAME=$(id -un)

# TEST if the command succeeded
if [[ "${?}" -ne 0 ]]
then
    echo "ID Command failed"
    exit 1
fi

echo "USER_NAME => ${USER_NAME}"
# You can use a string test conditional
USER_NAME_TO_TEST_FOR='vagrant'

if [[ "${USER_NAME}" == "${USER_NAME_TO_TEST_FOR}" ]]
then
    echo "Your username matches ${USER_NAME_TO_TEST_FOR}"
fi
# Test for != (not equal) for the string

if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
    echo "Your username does not ${USER_NAME_TO_TEST_FOR}"
fi

exit 0