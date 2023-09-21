#!/usr/bin/env bash
#
# Update the upstream to a specific commit. If this fails then it may leave
# your working tree in a bad state. You can recover by using Git to reset:
# git reset --hard HEAD.
set -euo pipefail

ref=${1:-HEAD}
out=${2:-upstream}
repo=github/cmark-gfm

rm -rf $out
git clone https://github.com/$repo $out
git -C $out checkout $ref
git -C $out rev-parse HEAD > ${out}.txt
rm -rf $out/.git

cd $out
make
cp ./build/src/config.h \
   ./build/src/cmark-gfm_version.h \
   ./build/src/cmark-gfm_export.h \
   ../override/include
make clean
