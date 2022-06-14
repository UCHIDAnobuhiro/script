#!/bin/sh

echo "start env.sh"

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
C_W_PATH=`awk '/path_client_workspace/ {print $2}' setting`
S_W_PATH=`awk '/path_server_workspace/ {print $2}' setting`

DESCRIPTION=$1
C_DESDIR=$C_W_PATH/$1
S_DESDIR=$S_W_PATH/$1
SSH_IP=$2

C_WORKDIR="$C_DESDIR"
S_WORKDIR="$S_DESDIR"
ENV=$C_WORKDIR/environment
RESULT=$C_WORKDIR/result"_$DESCRIPTION"

echo "##"
echo "## workdir is $C_WORKDIR"
echo "##"
mkdir -p $C_WORKDIR

DATE_START=$(/bin/date +"%Y%m%d")
TIME_START=$(/bin/date +"%H%M")

echo -n "Date: " >> $ENV
echo $DATE_START >> $ENV
echo -n "Time: " >> $ENV
echo $TIME_START >> $ENV
echo -n "Description: " >> $ENV
echo $DESCRIPTION >> $ENV
echo "" >> $ENV

echo "---------config------------" >> $ENV
echo "Server:" >> $ENV
echo "congestion control: New Reno" >> $ENV
echo "route:" >> $ENV
ssh -t -i $KEY_PATH $SSH_IP ip route >> $ENV

echo "Client:" >> $ENV
echo "congestion control: New Reno" >> $ENV
echo "route:" >> $ENV
echo "route:" >> $ENV
ip route >> $ENV
echo "" >> $ENV

./deal_mptcp.sh $C_WORKDIR $S_WORKDIR $RESULT 

