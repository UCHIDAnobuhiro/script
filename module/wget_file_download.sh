#!/bin/sh

OUTPUT_FILE=$1

wget -o $OUTPUT_FILE --ca-certificate=/home/mptcp-server/pquic/turbo/uchida/script/module/ca.pem --secure-protoco=TLSv1_2 https://example.org/download/test20M

rm test20M
