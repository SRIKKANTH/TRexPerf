csv_filename1=TRexLogsDPDK_Max.csv
csv_filename2=TRexLogsNonDPDK_Max.csv
Test1Name=`echo $csv_filename1 | sed "s/\.csv//"`
Test2Name=`echo $csv_filename2 | sed "s/\.csv//"`
comp_csv_filename=${Test1Name}_Vs_${Test2Name}.csv

cmp_csv_filename=TRexLogsNonDPDK_Max.csv

TestNames_1=(`cat $csv_filename1 | sed "s/,/ /g"| awk '{print $5}'`)
TestNames_2=(`cat $csv_filename2 | sed "s/,/ /g"| awk '{print $5}'`)
echo ${Test1Name}_Vs_${Test2Name} > $comp_csv_filename
echo "RxThroughputs_1,RxThroughputs_2,TxThroughputs_1,TxThroughputs_2,MaxPacketsPerSec_1,MaxPacketsPerSec_2,MaxConnectionsPerSec_1,MaxConnectionsPerSec_1,TestName" >> $comp_csv_filename

if [ ${#TestNames_1[@]} -gt ${#TestNames_2[@]} ]
then
  length=${#TestNames_1[@]}
  TestNames=("${TestNames_1[@]}")
else
  length=${#TestNames_2[@]}
  TestNames=("${TestNames_2[@]}")
fi

count=0

while [ $count != $length ]
do
  RxThroughputs_1=`cat $csv_filename1 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $1}'`
  RxThroughputs_2=`cat $csv_filename2 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $1}'`
  TxThroughputs_1=`cat $csv_filename1 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $2}'`
  TxThroughputs_2=`cat $csv_filename2 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $2}'`
  MaxPacketsPerSec_1=`cat $csv_filename1 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $3}'`
  MaxPacketsPerSec_2=`cat $csv_filename2 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $3}'`
  MaxConnectionsPerSec_1=`cat $csv_filename1 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $4}'`
  MaxConnectionsPerSec_2=`cat $csv_filename2 | grep -wh ${TestNames[$count]} | sed "s/,/ /g"| awk '{print $4}'`

  echo "$RxThroughputs_1,$RxThroughputs_2,$TxThroughputs_1,$TxThroughputs_2,$MaxPacketsPerSec_1,$MaxPacketsPerSec_2,$MaxConnectionsPerSec_1,$MaxConnectionsPerSec_2,${TestNames[$count]}"
  echo "$RxThroughputs_1,$RxThroughputs_2,$TxThroughputs_1,$TxThroughputs_2,$MaxPacketsPerSec_1,$MaxPacketsPerSec_2,$MaxConnectionsPerSec_1,$MaxConnectionsPerSec_2,${TestNames[$count]}" >> $comp_csv_filename
  ((count++))
done

sed -i "s/,,/,NA,/g"  $comp_csv_filename
