#!/bin/sh

INTERFACE=$1
TSHARK_RULE=$2
OUTPUT_FILE=$3

echo interface:$INTERFACE
echo option:$TSHARK_RULE
echo output_file:$OUTPUT_FILE

tshark -s 134 -i $INTERFACE -f "$TSHARK_RULE" > $OUTPUT_FILE &

