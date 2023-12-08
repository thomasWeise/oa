#!/bin/bash

# Make the book.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the book building script."

currentDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We are working in directory: '$currentDir'."
scriptDir="$currentDir/scripts"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The script directory is '$scriptDir'."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): First we delete all left over data."
rm "book.pdf" || true
rm -rf "$currentDir/website" || true

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Initialization: We install all required Python packages from requirements.txt."
pip install --no-input --timeout 360 --retries 100 -r requirements.txt
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished installing the requirements, now printing all installed packages."
pip freeze
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished printing all installed packages."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We now execute the pdflatex compiler script."
"$scriptDir/pdflatex.sh" "book.tex"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We now execute the website building script."
"$scriptDir/website.sh"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We have finished the book building process."


