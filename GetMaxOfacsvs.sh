MaxFileName="0_MaxFile.csv"
csv_filename1=`ls *.csv | head -1`
TestNames=(`cat $csv_filename1 | sed "s/,/ /g"| grep -v TestName|awk '{print $5}'`)

head -1 $csv_filename1 > $MaxFileName
i=0
while [ "x${TestNames[$i]}" != "x" ]
do
  echo ${TestNames[$i]}
  MaxRxThroughput=`grep -r "${TestNames[$i]}" . | sed "s/,/ /g" | sed s/[A-Z]bps//|awk '{print $2}'| sort -n| tail -1`
  MaxTxThroughput=`grep -r "${TestNames[$i]}" . | sed "s/,/ /g" | sed s/[A-Z]bps//|awk '{print $3}'| sort -n| tail -1`
  MaxPacketsPerSec=`grep -r "${TestNames[$i]}" . | sed "s/,/ /g" | sed s/[A-Z]bps//|awk '{print $4}'| sort -n| tail -1`
  MaxConnectionsPerSec=`grep -r "${TestNames[$i]}" . | sed "s/,/ /g" | sed s/[A-Z]bps//|awk '{print $5}'| sort -n| tail -1`
  echo ",$MaxRxThroughput,$MaxTxThroughput,$MaxPacketsPerSec,$MaxConnectionsPerSec,${TestNames[$i]}" >> $MaxFileName
  ((i++))
done


MAX_csv_file_sorted=0_Max_sorted.csv
echo ",MaxRxThroughput,MaxTxThroughput,MaxPacketsPerSec,MaxConnectionsPerSec,TestName" > $MAX_csv_file_sorted
cat $MaxFileName | grep -v Mbps| grep -v [0-9]bps | grep Gbps| sed "s/Gbps/-/"| sed "s/,/ /g"| sort -nr |sed "s/ /,/g" | sed "s/-/Gbps/" >> ${MAX_csv_file_sorted}
