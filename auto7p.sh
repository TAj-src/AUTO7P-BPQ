#!/bin/bash
##################################################################
#
# File         : auto7p.sh (this is called by req7p.sh)
# Descriptipon : 7plus request script for LinBPQ
# Author       : G7TAJ@GB7BEX.#38.GBR.EU (Steve)
#
# Install in a directory off the BASE_DIR (e.g. /home/pi/linbpq/scripts/)
# Change variables to match your system
#
# You need an export FWD in BPQMail to export P-type msgs to the below directory
#
# add in CRONTAB before you call
# e.g.
# #Check for Auto7P msgs
# 0 1 * * * /home/<usr>/linbpq/scrips/req7p.sh > /dev/null 2>&1
#
# Replace /dev/null if you want to log the output (e.g. /tmp/req7p.log)
#
#
##################################################################



# User configuration.
XBPQ_BASE="/home/taj/linbpq"
XBPQ_BASEDIR="/home/taj/linbpq/7plus/" # Path of the LinBPQ dir on your system.
XBPQ_FILESDIR="/home/taj/linbpq/Files/" # Path to the downloadable files.
XBPQ_MAILIN="$XBPQ_BASE/Mail/Import/mail.in"
TMP_DIR=$XBPQ_BASEDIR/tmp

SPLUS_PROG="7plus"
SPLUSCMD=$XBPQ_BASEDIR$SPLUS_PROG
SPLUS_FORMAT=$XBPQ_BASEDIR/format.def



# End of user config stuff.

CALL=`echo $1 | cut -d- -f1`
PROGNAME=`basename "$2"`
VERSION='V0.01b'

# Some author's indentification.
   echo ' '
   echo 'The Auto7p server for Linux and BPQMail by G7TAJ@GB7BEX.#38.GBR.EU'
   echo 'Version '$VERSION' ' $VERSIONSTRING
   echo ' '

# Check if PROGNAME is not empty, otherwise print help message.
if [ "$2" = '' ]
 then
   echo 'To use the Auto7p, type: Auto7p <callsign> <filename>'
   echo '<callsign> is the callsign the message will be from'
   echo '<filename> is the file to download.'
 elif [ -d "$XBPQ_FILESDIR$2" ] # Check if file is not a directory
 then
   echo 'You typed a directory name!'
 elif [ -f "$XBPQ_FILESDIR$2" ] # Check if file exists
  then
   # Welcome and activation
   echo 'The 7plus server is now processing '$PROGNAME 'requested by '$CALL
   echo ' '
 # Copy file to /tmp dir to work on it.


   cp $XBPQ_FILESDIR$2 $TMP_DIR
   cd $TMP_DIR
 # 7plus the programm.
   $SPLUSCMD -sb 5000 -send2 "sp $CALL < AUTO7P" -t /EX -K -J -tb $SPLUS_FORMAT $PROGNAME

  #( grep successful && echo 'Processing succesfull!' ))

 # Throw used program in the bin.
  rm $PROGNAME
# Check if there is only one *.7pl file, or multiple *.p?? files. After checking copy the files in the mail.in and append it to mail.in.
  if [ -f *.upl ]
  then
     cat *.upl >> mail.in
     cat mail.in >> $XBPQ_MAILIN
     rm *.upl
     rm mail.in
     if [ "$?" = 0 ]
     then
       echo 'The 7plus mail will be ready for download in a few seconds.'
     fi
  fi
  else
   echo 'That file does not exist!'
# Tell user 7plserv is finished.
 fi

cd $XBPQ_BASEIDR
exit 0
