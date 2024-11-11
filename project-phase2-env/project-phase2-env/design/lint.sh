#!/bin/bash

for vfile in *.v; do
  echo Lint "$vfile"
  java -cp ../check Vcheck "$vfile"
done
