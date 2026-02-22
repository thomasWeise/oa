#!/bin/bash -

exit 0  # temporary
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

# Find the Python interpreter.
if [[ $(declare -p PYTHON_INTERPRETER 2>/dev/null) != declare\ ?x* ]]; then
  export PYTHON_INTERPRETER="$(readlink -f "$(which python3)")"
fi

"$PYTHON_INTERPRETER" -m pip install --require-virtualenv "${packages[@]}" 1>/dev/null 2>&1

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
