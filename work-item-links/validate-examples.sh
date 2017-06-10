#!/bin/bash

# Validates the examples using an NPM package called jsaonapi-validator.

#set -x
set -e

JSON_VALIDATOR_DEFAULT=~/node_modules/jsonapi-validator/bin/jsonapi-validator.js
JSON_VALIDATOR="${JSON_VALIDATOR:-${JSON_VALIDATOR_DEFAULT}}"

if [ ! -e "${JSON_VALIDATOR}" ]; then
  echo "Cannot find the NPM program ${JSON_VALIDATOR}."
  echo ""
  echo "In order to install it, run \"npm i jsonapi-validator\"."
  echo "Alternatively you can specify the JSON_VALIDATOR environment"
  echo "varaible to point to $(basename ${JSON_VALIDATOR_DEFAULT})."
  exit 1
fi

TEMPFILE=$(mktemp --suffix=.json)
function cleanup() {
  rm -f ${TEMPFILE}
}
trap "cleanup" EXIT

find . -iregex ".*\.\(req\|res\)\.txt" | while read f
do
  echo -n "TESTING $f..."

  if [ ! -z "$(echo $f | grep "delete")" ]; then
    echo "IGNORING delete request" 
    continue
  fi

  cp $f $TEMPFILE

  # Strip off the HTTP header from the example
  sed -i '1,/^$/d' ${TEMPFILE}

  # Validate the file 
  ${JSON_VALIDATOR} -f ${TEMPFILE} 1>/dev/null

  if [ "$?" == 0 ]; then
    echo "OK"
  else
    echo "FAILURE"
  fi

done

