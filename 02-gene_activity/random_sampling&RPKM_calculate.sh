# parameter: $1 bed_file
mkdir temp
for j in {1000000,2000000,3000000,5000000,7000000,9000000,12000000,15000000,20000000}
do
for i in {1..100}
 do
  shuf -n $j $1 > ./temp/${1/bed/}$i.bed
 done

for i in ./temp/*bed
 do
     coverageBed -a ../annotation/araport_gene/protein.gb.bed -b $i -s > ${i/bed/}gb.count
 done

for i in ./temp/*count
 do
   awk 'BEGIN{s="'$j'"/1000000}{print $4,$7*1000/(s*$9)}' $i > ${i/count/}RPKM.txt
 done

for i in ./temp/*txt
 do
  cut -f 2 -d " " $i > ${i/txt/}txt2
 done

paste ./temp1/*txt2 > ${1/bed/}${j/000000/}M.txt

rm -rf temp

done

