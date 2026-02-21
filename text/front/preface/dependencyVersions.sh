#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.
# It uses the basic dependency versions given in bookbase and adds python tool information.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

# get the script directory
scriptDir="$(readlink -f "$(dirname "$0")")"
"bookbase/scripts/dependencyVersions.sh" "$scriptDir/__dependencyVersionsInner.sh" "${@:1}"
