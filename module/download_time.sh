#!/bin/sh

INPUT_FILE_NAME=$1
OUTPUT_TIME=$2

START_TIME=`cat $INPUT_FILE_NAME | awk '{print $2}' | awk 'NR==1 {print $0}'`
echo $START_TIME

FINISH_TIME=`cat $INPUT_FILE_NAME | awk '{print $2}' | awk 'END{print}'`
echo $FINISH_TIME

DOWNLOAD_TIME=`echo $FINISH_TIME $START_TIME | awk '{print $1 - $2}'` 

echo $DOWNLOAD_TIME s
echo $DOWNLOAD_TIME >> $OUTPUT_TIME
