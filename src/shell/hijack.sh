#!/bin/bash
WWWPATH="/var/www"
WEBSITES=(spiegel.de web.de)

for w in ${WEBSITES[@]}; do
	if [ "$1" == "add" ] ; then
		INDEXHTML="$WWWPATH/$w/htdocs/index.html"
		INDEXHACK="$WWWPATH/$w/htdocs/index_hack.html"
		cp -p $INDEXHACK $INDEXHTML
	else
		INDEXHTML="$WWWPATH/$w/htdocs/index.html"
		INDEXGOOD="$WWWPATH/$w/htdocs/index_good.html"
		cp -p $INDEXGOOD $INDEXHTML
	fi
done