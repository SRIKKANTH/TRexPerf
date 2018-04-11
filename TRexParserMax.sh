#log_filename=./imix_1518.yaml.log
log_files_list=(`ls *.log`)
csv_folder=CSV_files
mkdir $csv_folder
csv_file=$csv_folder/Max.csv
echo "" >> $csv_file
echo "" >> $csv_file
echo ",LogFileName,MaxRxThroughput,MaxTxThroughput,MaxPacketsPerSec,MaxConnectionsPerSec" > $csv_file

i=0

while [ "x${log_files_list[$i]}" != "x" ]
do
	log_filename=${log_files_list[$i]}
	test_name=`echo $log_filename | sed "s/\.yaml\.log//"`
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
		
		echo ",,$test_name,$MaxRX,$MaxTX,$MaxPPS,$MaxCPS" >> $csv_file

	else
		echo "Skipping $log_filename .."
	fi

	((i++))
done

