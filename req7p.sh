#!/bin/bash
##################################################################
#
# File         : req7p.sh (also needed is auto7p.sh)
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


BBS=GB7BEX
HR=.#38.GBR.EU
BBSCALL=$BBS$HR

BASE_DIR=/home/taj/linbpq
SP_BASE_DIR=$BASE_DIR/7plus
FILE_DIR=$BASE_DIR/Files
EXPORT_DIR=$BASE_DIR/Mail/Export/auto7p
LOG=auto7p.log

IN_MSG=0
IN_HEADER=0
FOUND_WP=0

#if no log - exit
if [ ! -f "$EXPORT_DIR/$LOG" ]; then
#  echo "no file..."
 exit 1;
fi

while read -r line; do
  first2=${line:0:2}
  first3=${line:0:3}


 if [[ $filenext -eq 1 ]]; then
        filenext=0
        parts=($(echo $line | tr " " "\n"))

	FILE=${parts[0]}
	FROMBBS="@${parts[2]}"

	FROMBBS="${FROMBBS/$'\r'/}"  # strip CR

#        echo "file request = [$FILE]"
#        echo "tmpbbs=[$FROMBBS]"
  fi



   if [ "$first2" == "R:" ] && [ $IN_MSG -eq 1 ]; then
	IN_HEADER=1
	LAST_R=$line
   fi


   if [ "$first2" != "R:" ] && [ $IN_HEADER -eq 1 ]; then  # we're out of the R lines so process the last R:
        IN_HEADER=0
	FOUND_WP=1
   fi


   if [ "$first3" == "/EX" ] && [ $IN_MSG -eq 1 ]; then  # END of message so process
	IN_MSG=0

        RUN_CMD="$SP_BASE_DIR/auto7p.sh $FROM_CALL$FROMBBS $FILE"
	echo $RUN_CMD

	$RUN_CMD

	FROM_CALL=""
	FROMBBS=""
	FOUND_WP=0
   fi


   if [ "$first3" == "SP " ] && [ $IN_MSG -eq 0 ]; then
        parts=($(echo $line | tr " " "\n"))
        IFS=". " read -r -a bbsarr <<< ${parts[3]}

        echo -n "Is this to our BBS? -> "

        if [ "${bbsarr[0]}" == $BBS ] || [ "${parts[2]}" == "<" ]; then
                FROM_CALL=${parts[5]}	   # if line = SP AUTO7P @ BBSCALL < CALLSIGN
		if [ "$FROM_CALL" == "" ]; then
	            FROM_CALL=${parts[3]}  # if line = SP AUTO7P < CALLSIGN
		fi
                echo "YES"

		#strip any @addr that might be there
		FROM_CALL=($(echo $FROM_CALL | tr "@" "\n"))

                echo "From - $FROM_CALL"
                filenext=1
                IN_MSG=1
                FOUND_WP=0
		FILE=""
        else
                echo "NO - skipping message."
        fi
   fi



done < "$EXPORT_DIR/$LOG"

rm "$EXPORT_DIR/$LOG"
