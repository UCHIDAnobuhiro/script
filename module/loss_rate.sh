#!/bin/sh

RETRANSMIT=$1
RECEIVE_PACKET=$2
OUTPUT_FILE=$3

RETRANSMIT_NUMBER=`cat $RETRANSMIT | awk 'END{print}'`
RECEIVE_PACKET_NUMBER=`cat $RECEIVE_PACKET | awk 'END{print}'`
HUNDRED="100"


LOSS_RATE=`echo $RETRANSMIT_NUMBER $RECEIVE_PACKET_NUMBER $HUNDRED  | awk '{print $1 / $2 * $3}'`

echo -n "retransmit:"
echo $LOSS_RATE %
echo $LOSS_RATE >> $OUTPUT_FILE

