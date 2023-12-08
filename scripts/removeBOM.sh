#!/bin/bash -

## This script removes a Byte Order Mark from a text file.
## $1 the text file

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

source="$(readlink -f "$1")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Trying to detect and, if present, remove Byte Order Mark (BOM) from document '$source'."

if ($( head -c3 "$source" | grep -q $'\xef\xbb\xbf' )); then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): 3-byte BOM detected in '$source', now removing it."
  tempFileName="$(tempfile)"
  tail --bytes=+4 "$source" >"$tempFileName"
  mv -f "$tempFileName" "$source"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done removing 3-byte Byte Order Mark (BOM) from document '$source'."
else
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): No BOM detected in '$source', doing nothing."
fi
