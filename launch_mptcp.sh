#!/bin/sh

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

read -p "Set LOSS route1(%):" LOSS1
read -p "Set LOSS route2(%):" LOSS2
read -p "Set Round-Trip-Delay route1(ms):" DELAY1
read -p "Set Round-Trip-Delay route2(ms):" DELAY2

# read -p "Is it QUIC(y/n)" SELECT
# if [ $SELECT = "y" ] ; then
#     echo "yes"
#     echo "QUIC-1path"
#     # sudo ifconfig $C_IF_1 up
#     # sudo ifconfig $C_IF_2 up
#     # ./route_1.sh
#     # ./route_2.sh
#     DESCRIPTION="QUIC-1path-eth_loss"-$LOSS"%"$DELAY"ms"
# else
#     echo "no"
#     echo "TCP-1path"
    # DESCRIPTION="TCP-1path-eth_loss"-$LOSS"%"$DELAY"ms"
# fi
read -p "Is it MPTCP:" SELECT
if [ $SELECT = "y" ] ; then
    echo "yes"
    echo "TCP-2path"
    DESCRIPTION="TCP-2path-eth_loss"-$LOSS1"%""$LOSS2""%"$DELAY1"ms""$DELAY2""ms"
    ./env_mptcp.sh $DESCRIPTION $SSH_IP 
fi
