#usage: ./extractJunctionFromBAM.sh input.bam threads
#example: ./extractJunctionFromBAM.sh CB.bam 8
#results: $1.intron.count.bed, the 5th column records the count of splicing events detected
samtools view -@ $2 $1 | cut -f 1,2,3,4,6 > $1.txt
awk '{gsub(/[0-9]*S/,"",$5);print $0}' $1.txt |  awk '$5~/N/{$6=$5;sub(/[0-9]*M/,"M",$6);sub(/83|163/,"+",$2);sub(/99|147/,"-",$2)
  split($5,a1,"M|N");split($6,a2,"[0-9]*")
  aa=$4
  for(i=1;i<=length(a2)-1;i++){
  if(a2[i]=="M" && a2[i+1]=="N" && a1[i]>=3 && a1[i+2]>=3){print $3,aa+a1[i]-1,aa+a1[i]+a1[i+1]-1,$1,1,$2;aa=aa+a1[i]}
  else{aa=aa+a1[i]}
  }}' OFS="\t" > $1.intron.txt
awk '!a[$1,$2,$3,$4,$6]++' $1.intron.txt | sort -k1,1 -k2,2n | groupBy -i - -g 1,2,3,6 -c 5 -o count > $1.intron.count.bed
rm -f $1.txt $1.intron.txt

