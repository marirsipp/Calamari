#!/bin/bash
#
# This hook will look for code comments marked '//no-commit'
#    - case-insensitive
#    - dash is optional
#    - there may be a space after the //
#
# for THISFILE in $(find . -name '*.tmp')
# do
THISFILE=$2
if [ ${THISFILE: -2} == ".m" ]
then
	DIR=$( dirname $THISFILE )
	FNAME=$( basename $THISFILE )
	NAME=`echo "$FNAME" | cut -d'.' -f1`
	  # EXTENSION=`echo "$FNAME" | cut -d'.' -f2`
	#NEWNAME="$DIR/$NAME.m"
	TMPNAME="$DIR/$NAME.tmp"
	  # TMPFILE=${THISFILE:2}
	#sed '/BEGIN USER-DEFINED/ r handy_codes_bySam/OF_scripts/testuser.tmp'
	sed '/BEGIN USER-DEFINED/r' $TMPNAME
fi
  # #LC_ALL=C sed -i '' 'd' $TMPFILE
# done