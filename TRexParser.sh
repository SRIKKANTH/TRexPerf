#log_filename=./imix_1518.yaml.log
log_files_list=(`ls *.log`)
csv_folder=CSV_files
mkdir $csv_folder
MAX_csv_file=$csv_folder/0_Max.csv

echo "" >> $MAX_csv_file
echo "" >> $MAX_csv_file
echo ",LogFileName,MaxRxThroughput,MaxTxThroughput,MaxPacketsPerSec,MaxConnectionsPerSec" > $MAX_csv_file

i=0
while [ "x${log_files_list[$i]}" != "x" ]
do
	log_filename=${log_files_list[$i]}
	test_name=`echo $log_filename | sed "s/\.yaml\.log//"`
	csv_file=$csv_folder/`echo $log_filename | sed "s/\.yaml\.log//"`.csv

	echo "Parsing $log_filename..."

	TotalTxArray=(`cat $log_filename | grep Total-Tx | awk '{print $3 $4}'`)
	MaxTX=`printf '%s\n'  ${TotalTxArray[@]} | grep Gbps| sort -n| tail -1`

	if [ "x${MaxTX}" == "x" ]
	then
		MaxTX=`printf '%s\n'  ${TotalTxArray[@]} | grep Mbps| sort -n| tail -1`
	fi
	if [ "x${MaxTX}" == "x" ]
	then
		MaxTX=`printf '%s\n'  ${TotalTxArray[@]} | grep Kbps| sort -n| tail -1`
	fi
	if [ "x${MaxTX}" == "x" ]
	then
		MaxTX=`printf '%s\n'  ${TotalTxArray[@]} | grep bps| sort -n| tail -1`
	fi

	if [ "x${TotalTxArray[0]}" != "x" ]
	then
		TotalRxArray=(`cat $log_filename | grep Total-Rx | awk '{print $3 $4}'`)
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
		DropRateArray=(`cat $log_filename | grep drop-rate | awk '{print $3 $4}'`)

		TotalPpsArray=(`cat $log_filename | grep Total-PPS | awk '{print $3 $4}'`)
		MaxPPS=`printf '%s\n'  ${TotalPpsArray[@]} | grep Gpps|  sort -n| tail -1`

		if [ "x${MaxPPS}" == "x" ]
		then
			MaxPPS=`printf '%s\n'  ${TotalPpsArray[@]} | grep Mpps|  sort -n| tail -1`
		fi
		if [ "x${MaxPPS}" == "x" ]
		then
			MaxPPS=`printf '%s\n'  ${TotalPpsArray[@]} | grep Kpps| sort -n| tail -1`
		fi
		if [ "x${MaxPPS}" == "x" ]
		then
			MaxPPS=`printf '%s\n'  ${TotalPpsArray[@]} | grep pps| sort -n| tail -1`
		fi

		TotalCpsArray=(`cat $log_filename | grep Total-CPS | awk '{print $3 $4}'`)
		MaxCPS=`printf '%s\n'  ${TotalCpsArray[@]} | grep Gcps|  sort -n| tail -1`
		if [ "x${MaxCPS}" == "x" ]
		then
			MaxCPS=`printf '%s\n'  ${TotalCpsArray[@]} | grep Mcps|  sort -n| tail -1`
		fi
		if [ "x${MaxCPS}" == "x" ]
		then
			MaxCPS=`printf '%s\n'  ${TotalCpsArray[@]} | grep Kcps| sort -n| tail -1`
		fi
		if [ "x${MaxCPS}" == "x" ]
		then
			MaxCPS=`printf '%s\n'  ${TotalCpsArray[@]} | grep cps| sort -n| tail -1`
		fi

		ExpectedPpsArray=(`cat $log_filename | grep Expected-PPS | awk '{print $3 $4}'`)
		ExpectedCpsArray=(`cat $log_filename | grep Expected-CPS | awk '{print $3 $4}'`)
		ExpectedBpsArray=(`cat $log_filename | grep Expected-BPS | awk '{print $3 $4}'`)
		ActiveFlowsArray=(`cat $log_filename | grep Active-flows | awk '{print $3}'`)
		OpenFlowsArray=(`cat $log_filename | grep Open-flows | awk '{print $3}'`)
		CpuUtilizationArray=(`cat $log_filename | grep "Cpu Utilization" | sed s/^.*://| sed "s/% /%-/"| sed "s/ //g"`)
		ClientsArray=(`cat $log_filename | grep "Clients" | grep -v Servers| awk '{print $6 }'`)
		ServersArray=(`cat $log_filename | grep "Servers" | awk '{print $6 }'`)
		SocketUtilArray=(`cat $log_filename | grep "Socket-util" | awk '{print $9 $10 }'`)
		SocketsPerClientArray=(`cat $log_filename | grep "Socket/Clients" | awk '{print $12 }'`)
		TotalQueueFullArray=(`cat $log_filename | grep "Total_queue_full" | awk '{print $3 }'`)
		CurrentTimeArray=(`cat $log_filename | grep "current time" | awk '{print $4 $5 }'`)

		echo ",$test_name,$MaxRX,$MaxTX,$MaxPPS,$MaxCPS" >> $MAX_csv_file

		echo ",,$test_name" > $csv_file
		echo ",,MaxRxThroughput,$MaxRX" >> $csv_file
		echo ",,MaxTxThroughput,$MaxTX" >> $csv_file
		echo ",,MaxPacketsPerSec,$MaxPPS" >> $csv_file
		echo ",,MaxConnectionsPerSec,$MaxCPS" >> $csv_file
		echo "" >> $csv_file
		echo "" >> $csv_file

		echo "CurrentTime,TxThroughput,RxThroughput,DropRate,PacketsPerSec,ConnectionsPerSec,ExpectedPacketsPerSec,ExpectedConnectionsPerSec,ExpectedBps,ActiveFlows,OpenFlows,CpuUtilization,Clients,Servers,SocketUtilisation,SocketsPerClient,TotalQueueFull" >> $csv_file
		count=0

		while [ "x${TotalTxArray[$count]}" != "x" ]
		do
			echo "${CurrentTimeArray[$count]},${TotalTxArray[$count]},${TotalRxArray[$count]},${DropRateArray[$count]},${TotalPpsArray[$count]},${TotalCpsArray[$count]},${ExpectedPpsArray[$count]},${ExpectedCpsArray[$count]},${ExpectedBpsArray[$count]},${ActiveFlowsArray[$count]},${OpenFlowsArray[$count]},${CpuUtilizationArray[$count]},${ClientsArray[$count]},${ServersArray[$count]},${SocketUtilArray[$count]},${SocketsPerClientArray[$count]},${TotalQueueFullArray[$count]}" >> $csv_file
			((count++))
		done
	else
		echo "Skipping $log_filename .."
	fi

	((i++))
done
cat $MAX_csv_file | grep -v Mbps| grep -v [0-9]bps | grep Gbps| sed "s/Gbps/-/"| sed "s/,/ /g"| sort -nr |sed "s/ /,/g" | sed "s/-/Gbps/" > ${MAX_csv_file}_sorted.csv
