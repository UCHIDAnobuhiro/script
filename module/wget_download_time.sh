#!/bin/sh

INPUT_FILE_NAME=$1
OUTPUT_TIME=$2

DOWNLOAD_TIME=`cat $INPUT_FILE_NAME | grep 100% | awk '{print $6}'| awk '{print substr($0,index($0,"=")+1)}'| awk '{print substr($0,0,index($0,"s"))}'`
echo $DOWNLOAD_TIME

# DOWNLOAD_TIME=`echo $MS_DOWNLOAD_TIME 1000 | awk '{print $1 / $2}'`
# echo $DOWNLOAD_TIME

echo $DOWNLOAD_TIME s
echo $DOWNLOAD_TIME >> $OUTPUT_TIME
