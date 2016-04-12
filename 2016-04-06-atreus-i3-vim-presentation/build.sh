#!/bin/bash

# Set Defaults
file="presentation"
outfile="presentation.pdf"
debug=false
issilent=true

# Allows us to hide all output
function silent() {
  if $issilent ;
  then
    "$@" > /dev/null 2>&1;
  else
    "$@";
  fi
}

# Remove temporary files if we're not debugging
function clean {
  if  $debug ;
  then
    return 0
  fi

  # Remove all the standard files
  silent rm *.aux *.bbl *.ps *.blg *.dvi *.log *.out *.toc *.run.xml *.bcf *.fff
  find . -name "*.aux" -type f|xargs rm

  # Remove the files that bibtoic generates
  silent rm $file*.bbl
}

# Handle stdin
while getopts "dvc" OPT
do
  case $OPT in
  d)  debug=true;;
  v)  issilent=false;;
  c)  clean
    exit 0;;
  [?])  echo "
Usage: $0 [-d] [-v] [-c] <tex file>

This script builds my resume, by default hiding subcommand
output and cleaning up after itself.

OPTIONS:
 -d   Debugging. Temporary files are not removed
 -v     Verbose e.g. subcommand output is printed
 -c     Clean temporary files and exit.

"
    exit 1;;
  esac
done


# Actual script to build the document
clean
echo "latex..."
silent pdflatex "$file"
echo "done"
clean

# Preview the pdf
# silent okular thesis.pdf &
silent wine "c:\Program Files\Tracker Software\PDF Editor\PDFXEdit.exe" "c:\\users\\lorentrogers\\My Documents\\dev\\presentations\\keyboard-vim-presentation\\presentation.pdf" &



