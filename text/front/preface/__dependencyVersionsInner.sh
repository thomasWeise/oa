#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.
# It uses the basic dependency versions given in bookbase and adds python tool information.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

hasOutput=false  # Do we have some output and need a separator?

# Make sure that all packages are installed.
packages=("moptipy")

# python3 -m pip install --require-virtualenv "${packages[@]}" 1>/dev/null 2>&1
python3 -m pip install -v --require-virtualenv "${packages[@]}" --log out_1.txt 1>out_2.txt 2>out_3.txt || true
for f in "out_1.txt" "out_2.txt" "out_3.txt"; do
sed -r \
-e 's/\x00/[NUL]/g' \
-e 's/\x01/[SOH]/g' \
-e 's/\x02/[STX]/g' \
-e 's/\x03/[ETX]/g' \
-e 's/\x04/[EOT]/g' \
-e 's/\x05/[ENQ]/g' \
-e 's/\x06/[ACK]/g' \
-e 's/\x07/[BEL]/g' \
-e 's/\x08/[BS]/g' \
-e 's/\x09/[HT]/g' \
-e 's/\x0A/[LF]/g' \
-e 's/\x0B/[VT]/g' \
-e 's/\x0C/[FF]/g' \
-e 's/\x0D/[CR]/g' \
-e 's/\x0E/[SO]/g' \
-e 's/\x0F/[SI]/g' \
-e 's/\x10/[DLE]/g' \
-e 's/\x11/[DC1]/g' \
-e 's/\x12/[DC2]/g' \
-e 's/\x13/[DC3]/g' \
-e 's/\x14/[DC4]/g' \
-e 's/\x15/[NAK]/g' \
-e 's/\x16/[SYN]/g' \
-e 's/\x17/[ETB]/g' \
-e 's/\x18/[CAN]/g' \
-e 's/\x19/[EM]/g' \
-e 's/\x1A/[SUB]/g' \
-e 's/\x1B/[ESC]/g' \
-e 's/\x1C/[FS]/g' \
-e 's/\x1D/[GS]/g' \
-e 's/\x1E/[RS]/g' \
-e 's/\x1F/[US]/g' \
-e 's/\x7F/[DEL]/g' "$f" > x.txt
sed 's/[^\x00-\x7F]//g' x.txt > y.txt
echo "================= [sep] ========"
cat y.txt
done;
exit 0
# Check the versions of the tools and packages.
for pack in "${packages[@]}"; do
  # For each tool or plugin, we get the version separately.
  version="$(python3 -m pip show "$pack" 2>/dev/null || true)"
  version="$(grep Version: <<< "$version")"
  version="$(sed -n 's/.*Version:\s*\([.0-9]*\)/\1/p' <<< "$version")"
  if [ -n "$version" ]; then  # ... and we concatenate them
    echo "$pack: $version"
    hasOutput=true
  fi
done

# separator if we have anything
if [ "$hasOutput" = true ]; then
  echo ""
fi
