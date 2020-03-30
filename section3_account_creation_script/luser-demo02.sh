#!/bin/bash

# Display the UID and username of the user executing the script
# Display if the user is the root user or not

# Display the UID
echo "Your UID => ${UID}"
# Display the user name
USER_NAME=$(id -un)
echo "Your UserName => ${USER_NAME}"
# Display if user is root or not
if [[ "${UID}" -eq 0 ]]
then
    echo 'YOU ARE ROOT'
else
    echo 'YOU ARE NOT ROOT'
fi