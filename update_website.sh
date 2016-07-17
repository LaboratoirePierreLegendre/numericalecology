#!/bin/sh

# Update the whole folder to the latest
cd /Users/numericalecology/numericalecology

/usr/bin/git pull origin master

# Update main website
pushd numecol
nanoc compile
if [ $? -eq 0 ];
then
  rsync -avz output/ /Users/numericalecology/Sites/ --delete --exclude Streaming
fi
popd

pushd Reprints
if [ $? -eq 0 ];
then
  rsync -avz . /Users/numericalecology/Sites/Reprints/ --exclude .git
fi
popd

pushd labo
rsync -avz . /Users/numericalecology/Sites/labo/ --exclude .git --exclude ".DS_Store"
popd

pushd prog
#mkdir -p /Users/numericalecology/Sites/labo
if [ $? -eq 0 ];
then
#  rsync -avz . /Users/numericalecology/Sites/labo/ --exclude .git --exclude ".DS_Store" -exclude README.md
  ditto . /Users/numericalecology/Sites/labo
  rm -rf /Users/numericalecology/Sites/labo/.git
fi

