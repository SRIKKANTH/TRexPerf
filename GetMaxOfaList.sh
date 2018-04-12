MaxRX=`printf '%s\n'  ${TotalRxArray[@]} | grep Gbps | sort -n| tail -1`
if [ "x${MaxRX}" == "x" ]
then
	MaxRX=`printf '%s\n'  ${TotalRxArray[@]} | grep Mbps | sort -n| tail -1`
fi
if [ "x${MaxRX}" == "x" ]
then
	MaxRX=`printf '%s\n'  ${TotalRxArray[@]} | grep Kbps| sort -n| tail -1`
fi
if [ "x${MaxRX}" == "x" ]
then
	MaxRX=`printf '%s\n'  ${TotalRxArray[@]} | grep bps| sort -n| tail -1`
fi

log_filename=./imix_1518.yaml.log
TotalTxArray=(`cat $log_filename | grep Total-Tx | awk '{print $3 $4}'`)

MaxVal=""

list=("P","T","G","M","K")
i=0
while [ "x${list[$i]}" != "x" -a "x${MaxVal}" == "x" ] 
do
	echo $i
	MaxVal=`printf '%s\n'  ${TotalRxArray[@]} | grep ${list[$i]} | sort -n| tail -1`
	((i++))
done
echo "Max Value: $MaxVal"
