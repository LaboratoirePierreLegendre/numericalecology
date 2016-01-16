#!/bin/sh

cd /Users/numericalecology/numecol
/usr/bin/git pull origin master
nanoc compile
if [ $? -eq 0 ];
then
  rsync -avz output/ /Users/numericalecology/Sites/ --delete --exclude Streaming
fi

cd /Users/numericalecology/Reprints
/usr/bin/git pull origin master
if [ $? -eq 0 ];
then
  rsync -avz . /Users/numericalecology/Sites/Reprints/ --exclude .git
fi

cd /Users/numericalecology/labo
rsync -avz . /Users/numericalecology/Sites/labo/ --exclude .git --exclude ".DS_Store"

cd /Users/numericalecology/prog
#mkdir -p /Users/numericalecology/Sites/labo
/usr/bin/git pull origin master
if [ $? -eq 0 ];
then
#  rsync -avz . /Users/numericalecology/Sites/labo/ --exclude .git --exclude ".DS_Store" -exclude README.md
  ditto /Users/numericalecology/prog /Users/numericalecology/Sites/labo
  rm -rf /Users/numericalecology/Sites/labo/.git
fi

