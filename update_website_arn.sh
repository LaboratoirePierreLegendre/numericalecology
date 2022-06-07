#!/bin/sh

date
# Update the whole folder to the latest
cd /Users/legendrepierre/numericalecology

/usr/bin/git pull origin main
if [ $? -ne 0 ];
then
  echo "There was an issue with the git update. Exiting."
  exit 1
fi

# Update main website (it's in plain HTML)
rsync -avz numecol/ /Library/WebServer/Documents/ --delete --exclude Streaming

pushd Reprints
if [ $? -eq 0 ];
then
  rsync -avz . /Library/WebServer/Documents/Reprints/ --exclude .git
fi
popd

# Note: folder 'prog' is represented as 'labo' on the website
pushd prog
#mkdir -p /Users/numericalecology/Sites/labo
if [ $? -eq 0 ];
then
#  rsync -avz . /Library/WebServer/Documents/labo/ --exclude .git --exclude ".DS_Store" -exclude README.md
  ditto . /Library/WebServer/Documents/labo
  rm -rf /Library/WebServer/Documents/labo/.git
fi

