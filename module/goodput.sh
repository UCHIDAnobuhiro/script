#!/bin/bash

FILE_LOG=$1
TIME_LOG=$2
OUTPUT_FILE=$3

FILE_LARGE=`cat $FILE_LOG | awk 'END{print}'`
TIME=`cat $TIME_LOG | awk 'END{print}'`

#debug用
# echo $FILE_LARGE
# echo $TIME


GOODPUT=`echo $FILE_LARGE $TIME | awk '{print $1 / $2}'`
MB_GOODPUT=`echo $GOODPUT 1000000 | awk '{print $1 / $2}'`

echo -n "goodput:"
echo $MB_GOODPUT Mbit/s
echo $MB_GOODPUT >> $OUTPUT_FILE

