#!/bin/bash

# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/

curl -s -O $1
echo "$2 $(basename $1)" | sha512sum --check --status
return $?