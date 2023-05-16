#!/bin/bash

# Generated through ChatGPT
# Took 3h, was not worth it

# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/

# Retrieve the available versions of libclang bindings
available_versions=$(pip3 index versions clang | grep 'Available versions:' | sed 's/Available versions: //' | tr -d '\n' | sed 's/,/\n/g')

# Find the matching version
matching_version=""
for version in $available_versions; do
  if [[ -f "/usr/lib64/libclang.so.$version" ]]; then
    matching_version=$version
    break
  fi
done

# Check if a matching version was found
if [[ -z $matching_version ]]; then
  echo "No matching version of libclang found."
  exit 1
fi

# Update the requirements file
sed -i "s/clang==.*$/clang==$matching_version/g" /opt/requirements.txt

# Create symlinks for all files matching the pattern
for file in /usr/lib64/libclang.so.*; do
  if [[ -f $file ]]; then
    version=$(basename "$file" | sed -r 's/libclang.so.([0-9.]+)/\1/')
    ln -sf "$file" "/usr/lib64/libclang-$version.so"
  fi
done

echo "Requirements file updated and symlinks created successfully."
