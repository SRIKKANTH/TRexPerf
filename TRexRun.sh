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

sleep 10
if pgrep -x "t-rex-64" > /dev/null
then
	echo "Running"
	sleep ${duration}
	pkill t-rex-64
else
	echo "Stopped"
fi

sleep 5

((count++))
done
