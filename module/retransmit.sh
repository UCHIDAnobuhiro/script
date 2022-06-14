#/bin/sh

SEND=$1
RECEIVE=$2
OUTPUT_FILE=$3

SEND_TOTAL_PACKET=`cat $SEND | awk 'END{print}'`
RECEIVE_TOTAL_PACKET=`cat $RECEIVE | awk 'END{print}'`
RETRANSMIT=`echo $SEND_TOTAL_PACKET $RECEIVE_TOTAL_PACKET| awk '{print $1 - $2}'`

echo -n "retrasmit:"
echo $RETRANSMIT
echo $RETRANSMIT >> $OUTPUT_FILE
