#!/bin/bash -

## pdflatex Compiler Script
## $1 the document to compile

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the pdflatex compiler script."

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The script directory is '$scriptDir'."
currentDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We are working in directory: '$currentDir'."
fullDocumentPath="$(readlink -f "$1")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The full document path is '$fullDocumentPath'."
relativeDocumentPath="$(python3 -c "import os.path; print(os.path.relpath('$fullDocumentPath','${currentDir}'))")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The relative document path is '$relativeDocumentPath'."
documentName="${relativeDocumentPath%%.*}"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The base name of the document is '$documentName'."

texProgram=("$(which pdflatex)" "-halt-on-error" "-interaction=nonstopmode" "$documentName")
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use ${texProgram[@]} to compile the document."
bibProgram="$(readlink -f "$(which biber)")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use '$bibProgram' to process bibliography files."
latexGitProgram=("$(readlink -f "$(which python3)")" "-m" "latexgit.aux")
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use latexgit like ${latexGitProgram[@]}."
makeIndexProgram="$(readlink -f "$(which makeindex)")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use '$makeIndexProgram' to make the index."
makeGlossariesProgram="$(readlink -f "$(which makeglossaries)")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use '$makeGlossariesProgram' to make the glossaries."

cd "$currentDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): First we will do some cleaning up temporary files from other LaTeX runs and also delete any pre-existing version of '$documentName.pdf'."

acnFile="$documentName.acn"
acrFile="$documentName.acr"
algFile="$documentName.alg"
glgFile="$documentName.glg"
gloFile="$documentName.glo"
glsFile="$documentName.gls"
idxFile="$documentName.idx"
istFile="$documentName.ist"
slgFile="$documentName.slg"
sloFile="$documentName.slo"
slsFile="$documentName.sls"

rm "$acnFile" || true
rm "$acrFile" || true
rm "$algFile" || true
rm "$documentName.aux" || true
rm "$documentName.bbl" || true
rm "$documentName.bcf" || true
rm "$documentName.blg" || true
rm "$documentName-blx.bib" || true
rm "$documentName.dvi" || true
rm "$documentName.ent" || true
rm "$glgFile" || true
rm "$gloFile" || true
rm "$glsFile" || true
rm "$idxFile" || true
rm "$istFile" || true
rm "$documentName.ilg" || true
rm "$documentName.ind" || true
rm "$gloFile" || true
rm "$documentName.latexgit.dummy" || true
rm "$documentName.loa" || true
rm "$documentName.lof" || true
rm "$documentName.log" || true
rm "$documentName.lot" || true
rm "$documentName.nav" || true
rm "$documentName.out" || true
rm "$documentName.out.ps" || true
rm "$documentName.pdf" || true
rm "$documentName.ps" || true
rm "$documentName.run.xml " || true
rm "$slgFile" || true
rm "$sloFile" || true
rm "$slsFile" || true
rm "$documentName.snm" || true
rm "$documentName.spl" || true
rm "$documentName.synctex" || true
rm "$documentName.synctex.gz" || true
rm "$documentName.toc" || true
rm "$documentName.upa" || true
rm "$documentName.upb" || true
rm "$documentName.vrb" || true
rm "$documentName.xcp" || true
rm "texput.log" || true

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now removing Unicode BOMs of .tex and .sty files, if any, as they will confuse LaTeX compilers"
find "$currentDir" -name '*.sty' -exec "$scriptDir/removeBOM.sh" "{}" \;
find "$currentDir" -name '*.bib' -exec "$scriptDir/removeBOM.sh" "{}" \;
find "$currentDir" -name '*.tex' -exec "$scriptDir/removeBOM.sh" "{}" \;

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will now perform runs of the tool chain no internal files change anymore."

watchFileContents=""
oldWatchFileContents="old"
cycle=0

while [ "$watchFileContents" != "$oldWatchFileContents" ] ; do
  cycle=$((cycle+1))
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now beginning build cycle $cycle."

  oldWatchFileContents="$watchFileContents"
  watchFileContents=""

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now running ${texProgram[@]}."
  set +o errexit
  "${texProgram[@]}" "$documentName"
  retVal=$?
  set -o errexit
  if(("$retVal" != 0)) ; then
    echo "Error: Program ${texProgram[@]} returned '$retVal' when compiling '$documentName'. Now exiting."
    exit "$retVal"
  fi

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished running '$texProgram'. Now looking for aux files to process."

  for auxFile in *.aux; do
    if [ -f "$auxFile" ]; then
      echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Discovered aux file '$auxFile'."
      fileContents="$(<$auxFile)"
      watchFileContents="${watchFileContents}${fileContents}"
      if [[ "$fileContents" = *"\\citation{"* ]] || \
         [[ "$fileContents" = *"\\abx@aux@cite{"* ]]  || \
         [[ "$fileContents" = *"\\abx@aux@segm"* ]]; then
        auxName="${auxFile%%.*}"
        echo "$(date +'%0Y-%0m-%0d %0R:%0S'): File '$auxFile' contains citations, so we applying '$bibProgram' to '$auxName'."
        "$bibProgram" "$auxName"
        echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished applying '$bibProgram' to '$auxFile'."
      else
        echo "$(date +'%0Y-%0m-%0d %0R:%0S'): File '$auxFile' does not contain any citation, so we do not apply '$bibProgram'."
      fi
    fi
  done

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now loading the bbl contents."
  for bblFile in *.bbl; do
    if [ -f "$bblFile" ]; then
      echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Discovered bbl file '$bblFile'."
      fileContents="$(<$bblFile)"
      watchFileContents="${watchFileContents}${fileContents}"
    fi
  done

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now applying latexgit as ${latexGitProgram[@]}."
  "${latexGitProgram[@]}" "$documentName"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished applying latexgit as ${latexGitProgram[@]}."

  if [ -f "$idxFile" ]; then
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): File '$idxFile' exists, so we now apply the make-index programm '$makeIndexProgram'."
    "$makeIndexProgram" "$documentName"
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished applying the make-index program '$makeIndexProgram'."
  else
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): File '$idxFile' does not exist, so we will not apply '$makeIndexProgram'."
  fi

acnFile="$documentName.acn"
acrFile="$documentName.acr"
algFile="$documentName.alg"
glgFile="$documentName.glg"
gloFile="$documentName.glo"
glsFile="$documentName.gls"
idxFile="$documentName.idx"
istFile="$documentName.ist"
slgFile="$documentName.slg"
sloFile="$documentName.slo"
slsFile="$documentName.sls"


  if [ -f "$acnFile" ] ||\
     [ -f "$acrFile" ] ||\
     [ -f "$algFile" ] ||\
     [ -f "$glgFile" ] ||\
     [ -f "$gloFile" ] ||\
     [ -f "$glsFile" ] ||\
     [ -f "$istFile" ] ||\
     [ -f "$slgFile" ] ||\
     [ -f "$sloFile" ] ||\
     [ -f "$slsFile" ] ; then
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Found at least one of '$acnFile', '$acrFile', '$algFile', '$glgFile', '$gloFile', '$glsFile', '$istFile', '$slgFile', '$sloFile', or '$slsFile' exists, so we now apply the make-glossaries programm '$makeGlossariesProgram'."
    "$makeGlossariesProgram" "$documentName"
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished applying the make-glossaries program '$makeGlossariesProgram'."
  else
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Neither  '$acnFile', '$acrFile', '$algFile', '$glgFile', '$gloFile', '$glsFile', '$istFile', '$slgFile', '$sloFile', nor '$slsFile' does exist, so we will not apply '$makeGlossariesProgram'."
  fi
  
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now loading the contents should no longer change when the built is complete."
  for suffix in "acn" "acr" "alg" "bbl" "bcf" "glg" "glo" "gls" "idx" "ind" "ist""slg" "slo" "sls" "toc"; do
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now looking for '$suffix' files."
    for theFile in *.$suffix; do
      if [ -f "$theFile" ]; then
        echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Discovered '$suffix' file '$theFile'."
        fileContents="$(<$theFile)"
        watchFileContents="${watchFileContents}${fileContents}"
      fi
    done
  done

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished build cycle $cycle."

  if (("$cycle" > 640)) ; then
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Something odd is happening: We have performed $cycle cycles. That's too many. Let's quit."
    break
  fi
done

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The tool chain has been applied until nothing changed anymore. We now check for errors."

latexWarningsCount=0
latexWarningString=""
logFile="$documentName.log"
if [ -f "$logFile" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We found the log file '$logFile' and check its contents."
  fileContents="$(<$logFile)"

  if [[ "$fileContents" = *" Warning: Citation"* ]] ; then
    latexWarningsCount=$((latexWarningsCount+1))
    latexWarningString="${latexWarningString}"$'\n'"${latexWarningsCount}. The $documentName contains undefined citations. Please fix them (search file $documentName.log for patterns ' Warning: Citation')."
  fi

  if [[ "$fileContents" = *"There were undefined references"* ]] ||\
     [[ "$fileContents" = *"Warning: Reference"* ]] ; then
    latexWarningsCount=$((latexWarningsCount+1))
    latexWarningString="${latexWarningString}"$'\n'"${latexWarningsCount}. The $documentName contains undefined references. Please fix them (search file $documentName.log for patterns 'undefined reference' and ' Warning: Reference')."
  fi

  if [[ "$fileContents" = *"multiply-defined labels"* ]] ; then
    latexWarningsCount=$((latexWarningsCount+1))
    latexWarningString="${latexWarningString}"$'\n'"${latexWarningsCount}. The $documentName contains multiply defined labels, i.e., labels defined more than once. Please fix them (search file $documentName.log for pattern 'multiply-defined')."
  fi

  if [[ "$fileContents" = *"Missing character: There is no"* ]] ; then
    latexWarningsCount=$((latexWarningsCount+1))
    latexWarningString="${latexWarningString}"$'\n'"${latexWarningsCount}. The $documentName contains some characters which cannot be printed. Please fix them (check file $documentName.log for pattern 'Missing character: There is no')."
  fi

  if [[ "$fileContents" = *"Empty ‘thebibliography’ environment"* ]] ; then
    latexWarningsCount=$((latexWarningsCount+1))
    latexWarningString="${latexWarningString}"$'\n'"${latexWarningsCount}. The $documentName contains an empty bibliography environment. Maybe you should not use a bibliography if there are no citations? Please fix them (check file $documentName.log for pattern 'Empty ‘thebibliography’ environment')."
  fi

  if [[ "$fileContents" = *"Float too large for page"* ]] ; then
    latexWarningsCount=$((latexWarningsCount+1))
    latexWarningString="${latexWarningString}"$'\n'"${latexWarningsCount}. At least one floating object such as a table or figure is too large. Please fix them (check file $documentName.log for pattern 'Float too large for page')."
  fi

fi

if (("$latexWarningsCount" < 1)) ; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): compilation finished successfully, no significant errors found."
else
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): compilation has not finished successfully, there were some fishy LaTeX warnings. Please check:$latexWarningString"
  exit 1
fi

if [ -f "$documentName.pdf" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We change the access permissions of the produced document '$documentName.pdf' to 777."
  chmod 777 "$documentName.pdf"
fi

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now cleaning up temporary files."
rm "$acnFile" || true
rm "$acrFile" || true
rm "$algFile" || true
rm "$documentName.aux" || true
rm "$documentName.bbl" || true
rm "$documentName.bcf" || true
rm "$documentName.blg" || true
rm "$documentName-blx.bib" || true
rm "$documentName.dvi" || true
rm "$documentName.ent" || true
rm "$glgFile" || true
rm "$gloFile" || true
rm "$glsFile" || true
rm "$idxFile" || true
rm "$istFile" || true
rm "$documentName.ilg" || true
rm "$documentName.ind" || true
rm "$gloFile" || true
rm "$documentName.latexgit.dummy" || true
rm "$documentName.loa" || true
rm "$documentName.lof" || true
rm "$documentName.log" || true
rm "$documentName.lot" || true
rm "$documentName.nav" || true
rm "$documentName.out" || true
rm "$documentName.out.ps" || true
rm "$documentName.ps" || true
rm "$documentName.run.xml" || true
rm "$slgFile" || true
rm "$sloFile" || true
rm "$slsFile" || true
rm "$documentName.snm" || true
rm "$documentName.spl" || true
rm "$documentName.synctex" || true
rm "$documentName.synctex.gz" || true
rm "$documentName.toc" || true
rm "$documentName.upa" || true
rm "$documentName.upb" || true
rm "$documentName.vrb" || true
rm "$documentName.xcp" || true
rm "texput.log" || true

for auxFile in *.aux; do
    if [ -f "$auxFile" ]; then
      echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Discovered aux file '$auxFile'."
      fileContents="$(<$auxFile)"
      if [[ "$fileContents" = *"\\citation{"* ]] || \
         [[ "$fileContents" = *"\\abx@aux@cite{"* ]]  || \
         [[ "$fileContents" = *"\\abx@aux@segm"* ]]; then
        auxName="${auxFile%%.*}"
        echo "$(date +'%0Y-%0m-%0d %0R:%0S'): File '$auxFile' contains citations, so we do bibtex cleanup for '$auxName'."
        rm "$auxName.bbl" || true
        rm "$auxName.bcf" || true
        rm "$auxName.blg" || true
        rm "$auxName-blx.bib" || true
      else
        echo "$(date +'%0Y-%0m-%0d %0R:%0S'): File '$auxFile' does not contain citations."
      fi
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now deleting file '$auxFile'."
    rm "$auxFile" || true
    fi
  done

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The pdflatex compiler script has finished. The compilation of document '$documentName' has been successfully completed."
