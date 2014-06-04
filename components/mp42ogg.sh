#!/bin/sh

#CONV="/usr/bin/echo"
CONV="/usr/bin/ffmpeg"
PARAMS="-loglevel quiet -i ""$1"

OUTPUT=$(basename "$1")
OUTPUT=${OUTPUT%.*}.ogg


$CONV $PARAMS $OUTPUT

