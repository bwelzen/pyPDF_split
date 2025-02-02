#!/bin/bash
source_path=./pyPDF_split
publish_pkg=pypdfsplit.pkg

version_number=`grep version $source_path/constants.py | sed -nE  's/^version[ ]+=[ ]+(.*)/\1/p' | tr -d \'\"`

if [ -z "$1" ]; then
  echo current version number: v$version_number
  echo pkg build, sign notarize, tag and push release to github
  echo usage:
  echo $0 \"release comment\"
  exit 0
fi

tag="v$version_number"

pycodesign.py -O $version_number pycodesign.ini

if [ $? -ne 0 ]; then
  echo signing failed
  exit
fi

git tag -a "$tag" -m "$1"
git commit -m "update pkg distribution $1" $publish_pkg
git push origin $tag
# git commit -m "repackage, sign, notarize $pkgname"
