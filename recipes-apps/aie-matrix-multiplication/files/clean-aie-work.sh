#!/bin/bash

DIR=$1

if [ -z "${DIR}" ]; then
	DIR=./Work
fi

files=$(find ${DIR} -type f)
echo "${files}"
echo "************"
rfiles=$(echo "${files}" | grep -v -E ".*_[0-9]$")
rfiles=$(echo "${rfiles}" | grep -v "aie_control.cpp")
echo "${rfiles}" | xargs -I{} rm -r {}

find ${DIR} -type d -empty -delete
