#!/bin/sh

EXTRACT="/usr/bin/ffprobe"
PARAMS="-loglevel quiet -show_streams -print_format json $1"

OUTPUT=$(basename "$1")
OUTPUT=${OUTPUT%.*}_streams.json


$EXTRACT $PARAMS > "$OUTPUT"

