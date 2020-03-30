#!/bin/bash

# examples of the sort command:
# -n => Numeric sort
# -r => Revert sort
# -g => Human reading sort

echo 'x' > example.text
echo 'y' >> example.text
echo 'ab' >> example.text
echo 'aa' >> example.text
echo 'aa' >> example.text
echo 'ca' >> example.text
echo 'Alphabetical Order'
echo 'Original'
cat example.text
echo
echo 'Sorted'
sort example.text

echo 'Applied to Numerals:'
echo '89' > example.text
echo '90' >> example.text
echo '901' >> example.text
echo '01' >> example.text
echo '089' >> example.text
echo '10000' >> example.text

echo 'Original'
cat example.text
echo
echo 'Sorted'
sort example.text

# Numeric Sort
echo 'Numeric Sort:'
echo '89' > example.text
echo '90' >> example.text
echo '901' >> example.text
echo '01' >> example.text
echo '089' >> example.text
echo '10000' >> example.text

echo 'Original'
cat example.text
echo
echo 'Sorted'
sort -n example.text
echo

rm example.text

echo 'Sort by Key'
# -t => Field separator (default empty space)
# -k => Key

cat /etc/passwd | sort -t ':' -k 3 -n # Numerical sort on the 3rd field, using ':' as separators
echo
# Human reading numerical sort
sudo du -h /var | sort -h

echo
echo "Sorting Port Numbers:"
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -un
echo Same as
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq

echo
echo 'Uniq requires input to be sorted'
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | uniq
echo
echo 'Display input occurrences'
echo 'Sorted:'
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq -c
echo 'Unsorted: '
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | uniq -c