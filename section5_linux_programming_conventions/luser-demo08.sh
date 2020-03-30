#!/bin/bash

# I/O Redirection examples

# Redirect STDOUT to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program.

read LINE < ${FILE}
echo "${LINE}"

# Redirect STDOUT to a file, overwriting the content
head -n 3 /etc/passwd > ${FILE}
echo
echo "Contents of ${FILE}"
cat $FILE

# Append STDOUT redirect to a file.

echo "${RANDOM}" >> ${FILE}
echo
echo "Contents of ${FILE}"
cat $FILE

# Redirect STDIN to a program,
# using FD (file descriptor) 0

read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a program,
# using FD (file descriptor) 1
# and overwriting the file

head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

# Redirect STDERR to a program,
# using FD (file descriptor) 2
ERR_FILE='/tmp/data.err'
head -n3 /etc/passwd /non/existing/file 2> ${ERR_FILE}
echo
echo "Contents of ${ERR_FILE}:"
cat ${ERR_FILE}

# Redirect both STDOUT and STDERR to a file.
head -n3 /etc/passwd /non/existing/file &> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

# Redirect both STDOUT and STDERR to a file,
# through a pipe (STDIN).

echo
head -n3 /etc/passwd /non/existing/file |& cat -n

# Send output to STDERR.
echo
echo 'This is not STDERR' | cat -n
echo 'This is STDERR!' >&2 | cat -n # cat wont get any input
echo 'This is STDERR! _(v2)' 1>&2 | cat -n # cat wont get any input
echo

# Discard STDOUT/STDERR using /dev/null

echo 'Discarding STDOUT:'
echo head -n3 /etc/passwd /non/existing/file > /dev/null
echo 'Discarding STDERR:'
echo head -n3 /etc/passwd /non/existing/file 2> /dev/null
echo 'Discarding STDERR and STDERR:'
echo head -n3 /etc/passwd /non/existing/file &> /dev/null
echo 'DONE'
rm ${FILE} ${ERR_FILE} &> /dev/null