import sys
import fileinput

for line in fileinput.input(encoding="utf-8"):
    sys.stdout.write(line)
