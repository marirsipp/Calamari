#!/bin/bash
#
# This hook will look for code comments marked '//no-commit'
#    - case-insensitive
#    - dash is optional
#    - there may be a space after the //
#
#IFS=$'\n'
    # git add $MFILE
  # fi
# done
# for THISFILE in $(find . -name '*.m' -or -name '*.m2')
# do
  # value=$( grep -ic "USER-DEFINED" $THISFILE )
  # if [ $value -eq 2 ]
  # then
THISFILE=$2  
if [ ${THISFILE: -2} == ".m" ]
then
	DIR=$( dirname $THISFILE )
	FNAME=$( basename $THISFILE )
	NAME=`echo "$FNAME" | cut -d'.' -f1`
	EXTENSION=`echo "$FNAME" | cut -d'.' -f2`
	NEWNAME="$DIR/$NAME.tmp" 
	MFILE=$THISFILE
	#MFILE=${THISFILE:2}
	#echo "Re-staging (with user-defined area removed): $MFILE"
	> "${NEWNAME}"
	sed -n '/BEGIN USER-DEFINED/,/END USER-DEFINED/{//!p}' $THISFILE >> "${NEWNAME}"
	sed '/BEGIN USER-DEFINED/,/END USER-DEFINED/ {//!d}' $MFILE
fi