#!/bin/sh

C_WORKDIR=$1
S_WORKDIR=$2
RESULT=$3

ENV=$C_WORKDIR/environment
#初期設定IPアドレス
S_IP_1=`awk '/address_server_1/ {print $2}' setting`
S_IP_2=`awk '/address_server_2/ {print $2}' setting`
C_IP_1=`awk '/address_client_1/ {print $2}' setting`
C_IP_2=`awk '/address_client_2/ {print $2}' setting`
SSH_IP=`awk '/ssh_ip/ {print $2}' setting`

#初期設定インターフェイス
S_IF_1=`awk '/interface_server_1/ {print $2}' setting`
S_IF_2=`awk '/interface_server_2/ {print $2}' setting`
C_IF_1=`awk '/interface_client_1/ {print $2}' setting`
C_IF_2=`awk '/interface_client_2/ {print $2}' setting`
S_PATH=`awk '/path_script/ {print $2}' setting`
KEY_PATH=`awk '/path_key/ {print $2}' setting`

#tsharkのルール設定
C_TSHARK_RULE_1="ip and ( src host $S_IP_1 or dst host $C_IP_1) and not arp and not port ssh"
C_TSHARK_RULE_2="ip and ( src host $S_IP_2 or dst host $C_IP_2) and not arp and not port ssh"
S_TSHARK_RULE_1="ip and ( src host $S_IP_1 or dst host $C_IP_1) and not arp and not port ssh"
S_TSHARK_RULE_2="ip and ( src host $S_IP_2 or dst host $C_IP_2) and not arp and not port ssh"
STOC_TSHARK_RULE="ip and ( src host $S_IP_1 or src host $S_IP_2) and (dst host $C_IP_1 or dst host $C_IP_2) and not arp and not port ssh"
ALL_TSHARK_RULE="ip and not arp and not port ssh"

#データの大きさbit数
FILE_LARGE=`echo 20 1024 1024 8 | awk '{print $1 * $2 * $3 * $4 }'`

#----------------------計測開始----------------------------------
for NUM in `seq 1 20`
do
    #tsharkのlog作成
    S_LOG_1="$S_WORKDIR/server_1_$NUM.log"
    S_LOG_2="$S_WORKDIR/server_2_$NUM.log"
    C_LOG_1="$C_WORKDIR/client_1_$NUM.log"
    C_LOG_2="$C_WORKDIR/client_2_$NUM.log"
    ALL_S_LOG="$S_WORKDIR/server_all_$NUM.log"
    ALL_C_LOG="$C_WORKDIR/client_all_$NUM.log"
    STOC_LOG="$S_WORKDIR/stoc_$NUM.log"
    DOWNLOAD_TIME="$C_WORKDIR/download_time"
    THROUGHPUT="$C_WORKDIR/throughput"
    SEND_TOTAL_PACKET_1="$C_WORKDIR/send_total_packet_1"
    SEND_TOTAL_PACKET_2="$C_WORKDIR/send_total_packet_2"
    RECEIVE_TOTAL_PACKET_1="$C_WORKDIR/receive_total_packet_1"
    RECEIVE_TOTAL_PACKET_2="$C_WORKDIR/receive_total_packet_2"
    RETRANSMIT_1="$C_WORKDIR/retransmit_1"
    RETRANSMIT_2="$C_WORKDIR/retransmit_2"
    LOSS_RATE_1="$C_WORKDIR/loss_rate_1"
    LOSS_RATE_2="$C_WORKDIR/loss_rate_2"
    RTT_LOG="$C_WORKDIR/rtt_log"

    ping -c 10 $S_IP_1 >> $RTT_LOG

echo "---------------------------server tshark start----------------------------------------------------"
    
    echo $S_WORKDIR
    ssh -i $KEY_PATH $SSH_IP "tshark -s 134 -i $S_IF_1 -f \"$S_TSHARK_RULE_1\" > $S_LOG_1 " &
    ssh -i $KEY_PATH $SSH_IP "tshark -s 134 -i $S_IF_2 -f \"$S_TSHARK_RULE_2\" > $S_LOG_2 " &
    ssh -i $KEY_PATH $SSH_IP "tshark -s 134 -i any -f \"$STOC_TSHARK_RULE\" > $STOC_LOG " &
    ssh -i $KEY_PATH $SSH_IP "tshark -s 134 -i any -f \"$ALL_TSHARK_RULE\" > $ALL_S_LOG " &
    

    echo "---------------------------client tshark start----------------------------------------------------"
    ./module/tshark_start.sh $C_IF_1 "$C_TSHARK_RULE_1" $C_LOG_1 
    ./module/tshark_start.sh $C_IF_2 "$C_TSHARK_RULE_2" $C_LOG_2
    ./module/tshark_start_without_interface.sh "$ALL_TSHARK_RULE" $ALL_C_LOG

    #tsharkの起動に時間がかかるので少しまつ
    sleep 5
    
    #clientのファイルダウンロード 
    ./module/wget_file_download.sh
    sleep 1
    
    #tsharkのkill
    sudo ./module/tshark_kill.sh
    ssh -t -i $KEY_PATH $SSH_IP "$S_PATH/module/tshark_kill.sh"
    sleep 5

    #-------------------評価項目----------------------------------

    S_LOG_1="$C_WORKDIR/server_1_$NUM.log"
    S_LOG_2="$C_WORKDIR/server_2_$NUM.log"
    STOC_LOG="$C_WORKDIR/stoc_$NUM.log"
    
    echo "----------------------------------------"
    echo $S_LOG_1
    echo $S_LOG_2
    echo $C_LOG_1
    echo $C_LOG_2
    echo "----------------------------------------"

    ./module/download_time.sh $STOC_LOG $DOWNLOAD_TIME
    ./module/throughput.sh $FILE_LARGE $DOWNLOAD_TIME $THROUGHPUT
    ./module/total_packet_number.sh $S_LOG_1 $SEND_TOTAL_PACKET_1
    ./module/total_packet_number.sh $S_LOG_2 $SEND_TOTAL_PACKET_2
    ./module/total_packet_number.sh $C_LOG_1 $RECEIVE_TOTAL_PACKET_1
    ./module/total_packet_number.sh $C_LOG_2 $RECEIVE_TOTAL_PACKET_2
    ./module/retransmit.sh $SEND_TOTAL_PACKET_1 $RECEIVE_TOTAL_PACKET_1 $RETRANSMIT_1
    ./module/retransmit.sh $SEND_TOTAL_PACKET_2 $RECEIVE_TOTAL_PACKET_2 $RETRANSMIT_2
    ./module/loss_rate.sh $RETRANSMIT_1 $SEND_TOTAL_PACKET_1 $LOSS_RATE_1
    ./module/loss_rate.sh $RETRANSMIT_2 $SEND_TOTAL_PACKET_2 $LOSS_RATE_2

    # 平均を算出
    if [ $NUM -eq 20 ] ; then
        AVE_DOWNLOAD_TIME="$C_WORKDIR/average_download_time"
        AVE_THROUGHPUT="$C_WORKDIR/average_throughput"
        AVE_RETRANSMIT_1="$C_WORKDIR/average_retransmit_1"
        AVE_RETRANSMIT_2="$C_WORKDIR/average_retransmit_2"
        AVE_LOSS_RATE_1="$C_WORKDIR/average_loss_rate_1"
        AVE_LOSS_RATE_2="$C_WORKDIR/average_loss_rate_2"
        ./module/average.sh $DOWNLOAD_TIME $AVE_DOWNLOAD_TIME
        ./module/average.sh $THROUGHPUT $AVE_THROUGHPUT
        ./module/average.sh $RETRANSMIT_1 $AVE_RETRANSMIT_1
        ./module/average.sh $RETRANSMIT_2 $AVE_RETRANSMIT_2
        ./module/average.sh $LOSS_RATE_1 $AVE_LOSS_RATE_1
        ./module/average.sh $LOSS_RATE_2 $AVE_LOSS_RATE_2

        cat $ENV >> $RESULT
        echo "----data----" >> $RESULT

        echo -n "download time" >> $RESULT
        cat $AVE_DOWNLOAD_TIME >> $RESULT

        echo -n "throughput: " >> $RESULT
        cat $AVE_THROUGHPUT >> $RESULT

        echo -n "retransmit route_1: " >> $RESULT
        cat $AVE_RETRANSMIT_1 >> $RESULT

        echo -n "retransmit route_2: " >> $RESULT
        cat $AVE_RETRANSMIT_2 >> $RESULT

        echo -n "loss rate route_1:" >> $RESULT
        cat $AVE_LOSS_RATE_1 >> $RESULT

        echo -n "loss rate route_2:" >> $RESULT
        cat $AVE_LOSS_RATE_2 >> $RESULT
        cat $RESULT

        echo $'\a'
        echo $'\a'
        echo $'\a'
        echo $'\a'
        echo $'\a'
    fi
done


