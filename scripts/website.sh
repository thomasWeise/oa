#!/bin/bash -

## pdflatex Compiler Script
## $1 the document to compile

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the website building script."

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The script directory is '$scriptDir'."
currentDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We are working in directory: '$currentDir'."

websiteDir="$currentDir/website"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will build the website into: '$websiteDir'."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): First, we make sure that '$websiteDir' is empty."
rm -rf "$websiteDir" || true
mkdir -p "$websiteDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Filtering the book into the website directory."
"$scriptDir/filterPdf.sh" "$currentDir/book.pdf" "$websiteDir/optimization_algorithms.pdf"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Put the LICENSE.md file into the website directory."
licenseFile="$currentDir/LICENSE.md"
pygmentize -f html -l text -O full -O style=default -o "$websiteDir/LICENSE.html" "$licenseFile"
cp "$licenseFile" "$websiteDir/LICENSE.md"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Put the requirements.txt file into the website directory."
requirementsFile="$currentDir/requirements.txt"
pygmentize -f html -l text -O full -O style=default -o "$websiteDir/requirements.html" "$requirementsFile"
cp "$requirementsFile" "$websiteDir/requirements.txt"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Ensuring that website is not jekyll-built."
touch "$websiteDir/.nojekyll"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building index.html from README.md."
PART_A='<!DOCTYPE html><html><title>'
PART_B='</title><style>code {background-color:rgb(204 210 95 / 0.3);white-space:nowrap;border-radius:3px}</style><body style="margin-left:5%;margin-right:5%">'
PART_C='</body></html>'
BASE_URL='https\:\/\/thomasweise\.github\.io\/oa\/'
echo "${PART_A}Optimization Algorithms${PART_B}$(python3 -m markdown -o html ./README.md)$PART_C" > "$websiteDir/index.html"
sed -i "s/\"$BASE_URL/\".\//g" "$websiteDir/index.html"
sed -i "s/=$BASE_URL/=.\//g" "$websiteDir/index.html"
sed -i "s/<\/h1>/<\/h1><h2>built on\&nbsp;$(date +'%0Y-%0m-%0d %0R:%0S')<\/h2>/g" "$websiteDir/index.html"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished copying README.md to index.html."


cd "$websiteDir"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now minifying website."
find -type f -name "*.html" -exec python3 -c "print('{}');import minify_html;f=open('{}','r');s=f.read();f.close();s=minify_html.minify(s,do_not_minify_doctype=True,ensure_spec_compliant_unquoted_attribute_values=True,keep_html_and_head_opening_tags=False,minify_css=True,minify_js=True,remove_bangs=True,remove_processing_instructions=True);f=open('{}','w');f.write(s);f.close()" \;
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done minifying website."

cd "$currentDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The website building script has successfully completed."

