#!/bin/sh

basicTest() {
  fileName=$1

  idris2 --no-color -p contrib -p xml -p odf -c "$fileName" -x main

  rm -rf build
}

checkODFContents() {
  fileName=$1
  re=$2

  if unzip -p "$fileName" content.xml | grep -q "$re"; then
    echo "\"$fileName\" contents match \"$re\""
  else
    echo "\"$fileName\" contents do not match \"$re\""
  fi
}
