#!/bin/sh

# Update the whole folder to the latest
cd /Users/numericalecology/numericalecology

/usr/bin/git pull origin main
if [ $? -ne 0 ];
then
  echo "There was an issue with the git update. Exiting."
  exit 1
fi

# Update main website (it's in plain HTML)
rsync -avz numecol/ /Users/numericalecology/Sites/ --delete --exclude Streaming

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

