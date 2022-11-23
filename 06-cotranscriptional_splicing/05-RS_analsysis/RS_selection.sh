for((i=1;i<=1410;i++))
  do
  aa=`head -n $i potential.RS.list | tail -n 1`
  echo $aa > temp.txt
  a=`awk '{print $1}' temp.txt`
  b=`awk '{print $2}' temp.txt`
  a1=`grep $a CB.final.intron.list| wc -l`
  a2=`grep $b CB.final.intron.list | wc -l`
  a3=`grep $a total.final.intron.list | wc -l`
  a4=`grep $b total.final.intron.list |wc -l`
  if [ $a1 = 1 ] && [ $a2 = 1 ] && [ $a3 = 0 ] && [ $a4 = 1 ]
      then echo $aa >> candidate.txt
      fi
  done
awk '{$16=NR;print $0}' OFS="\t" potential.RS.bed > potential.RS.bed2
for i in `cut -f 3 -d " " candidate.txt`;do awk '$16=='"$i"'' potential.RS.bed2 >> candidate.bed;done
