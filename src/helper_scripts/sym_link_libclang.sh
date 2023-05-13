#!/bin/bash

# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/

# Find every file matching libclang.so.NUM
# Creating Sym Links understandable for dumb python lib.
for file in $(find . -name 'libclang.so.*'); do
  num=$(echo "$file" | grep -oE 'libclang.so.[0-9]+' | grep -oE '[0-9]+')
  ln -s "$file" "libclang-$num.so"
done
