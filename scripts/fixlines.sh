#!/bin/bash -

# This script fixes line endings.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the line ending fixer script."

for suffix in "sh" "sty" "tex"; do
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Changing dos/windows CRLF to just LF line endings for '*.$suffix' files."
  find . -type f -name "*.$suffix" -exec dos2unix -s '{}' \;
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Removing trailing white space from line endings for '*.$suffix' files."
  find . -type f -name "*.$suffix" -print0 | xargs -r0 sed -e "s/[[:blank:]]\+$//" -i
done

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished with the line ending fixer script."

