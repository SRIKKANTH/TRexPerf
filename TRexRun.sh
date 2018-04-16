HOMEDIR="/root"
LOGDIR="$HOMEDIR/TRexLogs"
duration=300

if [ -d "$LOGDIR" ]; then
	mv $LOGDIR $LOGDIR-`date|sed "s/ /_/g"| sed "s/:/_/g"`
fi

mkdir $LOGDIR
cd cap2/
yaml_files_list=(`ls *.yaml`)
cd ..
count=0

while [ "x${yaml_files_list[$count]}" != "x" ]
do
	LOGFILE=$LOGDIR/${yaml_files_list[$count]}.log
	echo "yaml_files_list: $count : ${yaml_files_list[$count]}: $LOGFILE"

	./t-rex-64  -c 1  -m 10000000 -d ${duration} --nc --no-flow-control-change --active-flows 100000 -f cap2/${yaml_files_list[$count]} 2>&1 > $LOGFILE &

	time_elapsed=0
	while [[ x`pgrep -x "t-rex-64"` != "x" ]] && [[ $time_elapsed -lt ${duration} ]]
	do
		sleep 10
		time_elapsed=$((time_elapsed + 10))
		#echo $time_elapsed
	done
	pkill t-rex-64

	sleep 5

	((count++))
done
echo "Tests are completed."
echo "Parsing the logs now"
echo "All the logs are kept here: "$LOGDIR
echo "Parsed logs are available in .csv format here: "$LOGDIR/CSV_files
echo "Max Throughputs of each test are available in: "$LOGDIR/CSV_files/0_Max_sorted.csv
cd $LOGDIR
wget https://raw.githubusercontent.com/SRIKKANTH/TRexPerf/master/TRexParser.sh
bash TRexParser.sh
echo "TRex testing is completed"
