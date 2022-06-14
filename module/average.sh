#!/bin/sh

INPUT_LOG=$1
OUTPUT_LOG=$2

AVERAGE_TIME=`cat $INPUT_LOG | awk '{sum+=$1} END {print sum/NR}'`
# echo $AVERAGE_TIME
echo $AVERAGE_TIME >> $OUTPUT_LOG

