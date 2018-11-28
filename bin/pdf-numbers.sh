#!/bin/bash
name="${1%\.pdf}-numbers"
wd="$(pwd)"
dir=/tmp/pdf-numbers
mkdir -p "$dir"
cp "$1" "$dir/input.pdf"
cd "$dir"
pdflatex --jobname "$name" add-page-numbers.tex > /dev/null
mv "$name.pdf" "$wd"
rm -r "$dir"