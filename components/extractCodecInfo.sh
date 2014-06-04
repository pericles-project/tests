#!/bin/sh

EXTRACT="/usr/bin/ffprobe"
PARAMS="-loglevel quiet -show_format -print_format json $1"

OUTPUT=$(basename "$1")
OUTPUT=${OUTPUT%.*}_metadata.json


$EXTRACT $PARAMS > "$OUTPUT"

