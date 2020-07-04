#!/bin/bash
#
# tool to organize and cleanup screenshots
# - screenshots will be stored in directories broken down by day
# - filenames will just be the time on that day that the shot was taken
#
# example directory for July 18th, 2017: 
#   /Users/ericshreve/Pictures/screenshots/2017-18-07/
# example filename for screenshot taken at 10:54 AM: 10-54-00-AM.png
#
# normally I just set a crontab to run this M-F at 1pm

# directory where i am going to store screenshots
SSHOT_DIR=/Users/ericshreve/Pictures/screenshots

# logfile location
LOGFILE=/Users/ericshreve/Pictures/screenshots/screenshots.log

# desktop, default location where screenshots are saved (on my mac)
DIR=/Users/ericshreve/Desktop/*

# counter variables
SHOTS_PROCESSED=0
DIRS_MADE=0

# log some stuff
date >> $LOGFILE
echo "Starting to process files..." >> $LOGFILE

# for all the files on the Desktop
for f in $DIR
do	
	# only process if this is a screenshot file
	if [[ "$f" == *Screen\ Shot*\.png ]]; then
		
		# pull out the simple filename
		FNAME="$(echo $f | egrep -o 'Screen.*\.png')"

		# build the name of the destination directory
		DEST_DIR="$SSHOT_DIR/$(echo $f | egrep -o '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')"
		
		# if the destination directory doesn't exist then create it
		if [ ! -d "$DEST_DIR" ]; then
			mkdir "$DEST_DIR"

			# count new directories created
			((DIRS_MADE++))
		fi

		# move file to new directory
		mv "$f" "$DEST_DIR/"

		# rename file
		OLD_NAME="$DEST_DIR/$FNAME"

        # pull out just the time portion of the tilename
		NEW_NAME="$DEST_DIR/$(echo $f | egrep -o '[[:digit:]]{1,2}\.[[:digit:]]{2}\.[[:digit:]]{2}.*\.png')"

        # replace the two dots with dashes and the space with a dash
        NEW_NAME="$(echo ${NEW_NAME/./-})"
        NEW_NAME="$(echo ${NEW_NAME/./-})"
        NEW_NAME="$(echo ${NEW_NAME/ /-})"

        # actually rename the file
		mv "$OLD_NAME" "$NEW_NAME"

		# count number of files processed
		((SHOTS_PROCESSED++))
	fi
done

# log some stuff for fun
echo "Finished processing files..." >> $LOGFILE
echo "$SHOTS_PROCESSED screenshots moved" >> $LOGFILE
echo "$DIRS_MADE new directories made" >> $LOGFILE
echo "....." >> $LOGFILE