#! /bin/bash

#Auto generate agenda from previous days agenda, copy it over

FILE_NAME=${1}

NEW_AGENDA=$(tail -n +$(( 1 + $(grep -n "==" "${FILE_NAME}" | tail -n1 | cut -d: -f1) )) "${FILE_NAME}" | grep -v "✅" | grep . | awk '{print "-"$0}')

echo "==$(date +"%d-%m-%y")==" >> "${FILE_NAME}"
echo "${NEW_AGENDA}" >> "${FILE_NAME}"
echo "" >> "${FILE_NAME}"
