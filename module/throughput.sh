#!/bin/sh

LOG_FILE=$1
TIME_LOG=$2
OUTPUT_FILE=$3

# 列の抽出と合計
TOTAL_BYTE=`cat $LOG_FILE | awk '{sum+=$7} END {print sum}'`
# echo $TOTAL_BYTE

# biteに変換
TOTAL_BIT=`echo $TOTAL_BYTE 8 | awk '{print $1 * $2}'`
# echo $TOTAL_BIT

TIME=`cat $TIME_LOG | awk 'END{print}'`

# スループット
THROUGHPUT=`echo $TOTAL_BIT $TIME | awk '{print $1 / $2}'`

# 単位をMにする
MB_THROUGHPUT=`echo $THROUGHPUT 1000000| awk '{print $1 / $2}'`

echo -n "throughput:"
echo $MB_THROUGHPUT Mbit/s
echo $MB_THROUGHPUT >> $OUTPUT_FILE

