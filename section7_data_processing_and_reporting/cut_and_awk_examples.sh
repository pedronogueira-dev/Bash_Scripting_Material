#!/bin/bash

# Examples of the 'cut' and 'awk' functionalities

# Example of byte cut
echo 'Cutting byte'
echo 'this' | cut -b 1
echo
# Example of character cut
echo 'Cutting character'
echo 'this' | cut -b 2
echo
# Example of range cut characters
echo 'Cutting characters by range'
echo 'this' | cut -c 2-3
echo
# Example of index cut characers
echo 'Cutting characters by position'
echo 'this' | cut -c 1,3
echo
# Example of delimiter cut
echo 'Cutting using a delimiter'
echo -e 'this,two,three,four' | cut -d ',' -f 1,3
echo
# CSV File processing
echo 'USING A FILE'
touch example.csv

echo "First,Last" > example.csv
echo "John,Doe" >> example.csv
echo "Firstly,McLastly" >> example.csv
echo "mr. Firstly,McLastly" >> example.csv

# Example of delimiter cut
# Header of csv will be present
cut -d ',' -f 1 example.csv
echo

# USING GREP
echo 'Grep to match a token'
grep First example.csv
echo
echo 'Grep to match begining of a line'
grep '^First' example.csv
echo
echo 'Grep to match ending of a line'
grep 't$' example.csv
echo
echo 'Grep to match a a line'
grep '^First,Last$' example.csv
echo
echo 'Grep by negating matched line'
grep -v '^First,Last$' example.csv
echo

echo 'Processing CSV with grep to ignore the header and cut to obtain 1st column'
grep -v '^First,Last$' example.csv | cut -d ',' -f 1
echo
rm example.csv
# Limitations of cut
touch example.dat
echo "DATA:FirstDATA:Last" > example.dat
echo "DATA:JohnDATA:Doe" >> example.dat
echo "DATA:FirstlyDATA:McLastly" >> example.dat
echo "DATA:mr. FirstlyDATA:McLastly" >> example.dat

echo 'Cut Fails to remove complex delimiters (it is limited to 1 character)'
cut -d ':' -f 2 example.dat
echo

# AWK Command
echo 'Using awk'
awk -F 'DATA:' '{print $2}' example.dat
echo
echo 'Using grep and awk'
grep -v '^DATA:FirstDATA:Last$' example.dat | awk -F 'DATA:' '{print $2}'
echo
echo 'awk returning multiple fields'
echo 'Using awk'
awk -F 'DATA:' '{print $2, $3}' example.dat
echo
awk -F ':' '{print $1, $3}' /etc/passwd
echo
echo 'changing result delimiter (default is a space) and order of fields'
awk -F ':' -v OFS='-' '{print $1 , $3}' /etc/passwd
echo
awk -F ':' '{print "UID:$3 " ";" "LOGIN: $1"}' /etc/passwd
echo
echo 'Print Last field (NF)'
awk -F ':' '{print $NF }' /etc/passwd

# APPLYING EXPRESSIONS
echo 'applying expressions with AWK'
awk -F ':' '{print $(NF - 1)}' /etc/passwd
echo
rm example.dat

# PROCESSING IRREGULAR DATA
echo 'irregularly spaced file:'
echo 'L1C1          L1C2' > lines
echo '      L2C1  L2C2    ' >> lines
echo '  L3C1          L2C2' >> lines
echo -e 'L4C1\tL4C2    ' >> lines
cat lines
echo
echo 'applying awk:'
awk '{print $1, $2}' lines
rm lines
echo

# netstat -4nutl => prints all ports (to UDP -u and TCP -t, ipvc4) by number currently open (-l)
echo 'open ports:'
# Filtering Headers:
# netstat -nutl | grep -v '^A' | grep -v '^P'
# using extended regular expressions
echo 'Original Listing_'
netstat -nutl | grep -Ev '^Active|^Proto'
echo
echo 'Filtering by :'
# Cut fails due to spacing and data presence discrepancies
# netstat -nutl | grep -Ev '^Active|^Proto' | cut -d ':' -f 2
# netstat -4nutl | grep -Ev '^Active|^Proto' | awk '{print $4}' | cut -d ':' -f 2
netstat -4nutl | grep -Ev '^Active|^Proto' | awk '{print $4}' | awk -F ':' '{print $NF}'