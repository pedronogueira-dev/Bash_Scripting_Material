#!/bin/bash

# Examples of the Stream Editor (sed) command
# sed 's/search_pattern/replace_pattern/flags' => replace
# sed '/search_pattern/d' => delete

echo 'This is a solution' > sed_example.txt
echo 'This is not a solution' >> sed_example.txt
echo 'This was a solution' >> sed_example.txt

echo 'Example 1'
sed 's/ is not/ is/' sed_example.txt
echo 'File:'
cat sed_example.text
echo

echo 'Example 2 -global search, using different delimiters for the regex'
sed 's/ is/ was/g' sed_example.txt
sed 's: is: was:g' sed_example.txt
echo 'File:'
cat sed_example.txt
echo

echo 'Example 3 -> Alter file'
sed -i 's#is#was#2' sed_example.txt
echo 'File:'
cat sed_example.txt
echo


# EXAMPLE OF SED TO ALTER CONFIG FILES
echo "# User to run service as" > sed_example.txt
echo "User apache" >> sed_example.txt
echo >> sed_example.txt
echo >> sed_example.txt
echo "# Group to run service as" >> sed_example.txt
echo "Group apache" >> sed_example.txt

echo 'Comment removal:'
sed '/^#/d' sed_example.txt
echo
echo 'Empty Line removal:'
sed '/^$/d' sed_example.txt
echo

echo 'Combining expressions:'
sed '/^#/d ; /^$/d' sed_example.txt
echo

echo 'Replace content of config file:'
# Equivalent to: sed -e '/^#/d' -e '/^$/d' -e 's/apache/httpd/' sed_example.txt
sed '/^#/d ; /^$/d ; s/apache/httpd/' sed_example.txt
echo

# Use a File as a macro of alterations to perform
echo 'Using a file as sed pattern input:'
echo '/^#/d' > changes.sed
echo '/^$/d' >> changes.sed
echo 's/apache/httpd/' >> changes.sed
sed -f changes.sed sed_example.txt

# Apply changes on specific lines
echo 'Using Address'
sed '2 s/apache/httpd/' sed_example.txt # 2s/exp/exp/
echo
echo 'Using Expression'
sed '/Group/ s/apache/httpd/' sed_example.txt
echo
echo 'Using Ranged Addresses'
sed '1,3 s/run/execute/' sed_example.txt
echo
echo 'Using Ranged Expressions'
sed '/^$/,/^# Group/ s/run/execute/' sed_example.txt
rm sed_example.txt changes.sed
exit 0