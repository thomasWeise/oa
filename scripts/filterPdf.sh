#!/bin/bash -

# This script filters a PDF file and attempts to include as many fonts as possible.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the pdf filtering script."
fileIn="$1"
fileOut="$2"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will filter '$fileIn' to '$fileOut using ghostscipt."

gs -dAntiAliasColorImages=true \
   -dAntiAliasGrayImages=true \
   -dAntiAliasMonoImages=true \
   -dAutoFilterColorImages=false \
   -dAutoFilterGrayImages=false \
   -dAutoRotatePages=/None \
   -dBATCH \
   -dCannotEmbedFontPolicy=/Error \
   -dColorConversionStrategy=/LeaveColorUnchanged \
   -dColorImageFilter=/FlateEncode \
   -dCompressFonts=true \
   -dCompressStreams=true \
   -dDetectDuplicateImages=true \
   -dDownsampleColorImages=false \
   -dDownsampleGrayImages=false \
   -dDownsampleMonoImages=false \
   -dEmbedAllFonts=true \
   -dFastWebView=false \
   -dGrayImageFilter=/FlateEncode \
   -dHaveTransparency=true \
   -dMaxBitmap=2147483647 \
   -dNOPAUSE \
   -dOptimize=true \
   -dPassThroughJPEGImages=true \
   -dPassThroughJPXImages=true \
   -dPDFSTOPONERROR=true \
   -dPDFSTOPONWARNING=true \
   -dPreserveCopyPage=false \
   -dPreserveEPSInfo=false \
   -dPreserveHalftoneInfo=false \
   -dPreserveOPIComments=false \
   -dPreserveOverprintSettings=false \
   -dPreserveSeparation=false \
   -dPreserveDeviceN=false \
   -dPrinted=false \
   -dQUIET \
   -dSAFER \
   -dSubsetFonts=true \
   -dUNROLLFORMS \
   -sDEVICE=pdfwrite \
   -sOutputFile="$fileOut" "$fileIn" \
   -c "<</NeverEmbed [ ]>> setdistillerparams" \
   -q

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Successfully finished filtering '$fileIn' to '$fileOut using ghostscipt."

