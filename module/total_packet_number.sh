#!/bin/sh

INPUT_FILE_NAME=$1
OUTPUT_FILE_PACKET=$2

PACKET_NUMBER=`cat  $INPUT_FILE_NAME | awk '{print $1}' | awk 'END{print}'`


echo -n "total packet:"
echo $PACKET_NUMBER
echo $PACKET_NUMBER >> $OUTPUT_FILE_PACKET
