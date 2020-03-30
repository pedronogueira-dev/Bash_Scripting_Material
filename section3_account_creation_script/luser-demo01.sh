#!/bin/bash

echo 'Hello World!'
WORD='script'

# Use of inline variable
echo "this is a shell $WORD == this is a shell ${WORD}"

# Wrong use of inline variable
echo "this is a shell $WORDing exercise"

ENDING='ed'

echo "this is ${WORD}${ENDING}"

ENDING='s'
echo "there'll be more ${WORD}${ENDING}"
