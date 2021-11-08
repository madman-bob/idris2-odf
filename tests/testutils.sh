#!/bin/sh

basicTest() {
  fileName=$1

  idris2 --no-color -p contrib -p xml -p odf -c "$fileName" -x main

  rm -rf build
}
