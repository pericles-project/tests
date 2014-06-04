#!/bin/sh

# Converts a video file to ogg.
# The input filename is expected as command line argument.
# The ogg file is written to the current working directory and has the same
# basename as the input file.
# Requires the ffmpeg executable.

CONV="/usr/bin/ffmpeg"
PARAMS="-loglevel quiet -i ""$1"

OUTPUT=$(basename "$1")
OUTPUT=${OUTPUT%.*}.ogg


$CONV $PARAMS $OUTPUT

