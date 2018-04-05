#!/bin/sh

# Update the whole folder to the latest
cd /Users/numericalecology/numericalecology

/usr/bin/git pull origin master
if [ $? -ne 0 ];
then
  echo "There was an issue with the git update. Exiting."
  exit 1
fi

# Update main website
pushd numecol
# Disable nanoc for now as it's not installed
#nanoc compile
if [ $? -eq 0 ];
then
#  rsync -avz output/ /Users/numericalecology/Sites/ --delete --exclude Streaming
# The old version of the site is stored in the "nanoc" folder so we'll use that for now
# TODO: fix this so we generate the site from text files again
  rsync -avz nanoc/ /Users/numericalecology/Sites/ --delete --exclude Streaming
fi
popd

pushd Reprints
if [ $? -eq 0 ];
then
  rsync -avz . /Users/numericalecology/Sites/Reprints/ --exclude .git
fi
popd

# Note: folder 'prog' is represented as 'labo' on the website
pushd prog
#mkdir -p /Users/numericalecology/Sites/labo
if [ $? -eq 0 ];
then
#  rsync -avz . /Users/numericalecology/Sites/labo/ --exclude .git --exclude ".DS_Store" -exclude README.md
  ditto . /Users/numericalecology/Sites/labo
  rm -rf /Users/numericalecology/Sites/labo/.git
fi

