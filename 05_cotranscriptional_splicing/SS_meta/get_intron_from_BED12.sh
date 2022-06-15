while read line
do
  chr=`echo $line | cut -f 1 -d " "`
  left=`echo $line | cut -f 2 -d " "`
  transcript=`echo $line | cut -f 4 -d " "`
  strand=`echo $line | cut -f 6 -d " "`
  a1=(`echo $line | cut -f 11 -d " " | sed 's/,/\t/g'`)
  a2=(`echo $line | cut -f 12 -d " " | sed 's/,/\t/g'`)
  len=${#a1[@]}   #the length of exon
  let b=len-1
  aa=$left
  if [ $len -gt 1 ]
   then
   for ((i=0;i<=$b;i++))
       do
       let a=i+1
       if [ $a -le $b ]
       then
           let aa=aa+a1[$i]
           let bb=left+a2[$i+1]
           echo $chr $aa $bb $transcript $strand
           let aa=bb
       fi
       done
    fi
done  < $1
