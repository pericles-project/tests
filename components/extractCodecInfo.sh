#!/bin/sh

# Extracts information about the format of a media file.
# The input filename is expected as command line argument.
# The output file is in json format and is written to the current working
# directory. Its name is the basename of the input file with a "_format.json"
# suffix.
# Requires the ffprobe executable (part of the ffmpeg project).

EXTRACT="/usr/bin/ffprobe"
PARAMS="-loglevel quiet -show_format -print_format json $1"

OUTPUT=$(basename "$1")
OUTPUT=${OUTPUT%.*}_format.json


$EXTRACT $PARAMS > "$OUTPUT"

