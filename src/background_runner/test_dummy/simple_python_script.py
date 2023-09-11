# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/

# This is a test dummy which outputs STDIN to STDOUT.

import sys
import fileinput

for line in fileinput.input(encoding="utf-8"):
    sys.stdout.write(line)
