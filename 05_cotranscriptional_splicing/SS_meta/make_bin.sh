awk '{if($6=="+")print $0}' OFS="\t" $1.bed > temp.plus.bed
awk '{if($6=="-")print $0}' OFS="\t" $1.bed > temp.minus.bed
bedtools makewindows -b temp.plus.bed -n $2 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="+";print $0}' > temp.plus.bin.bed
bedtools makewindows -b temp.minus.bed -n $2 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="-";print $0}' > temp.minus.bin.bed
awk '{print $5}' temp.minus.bin.bed | tac > minus.order
paste minus.order temp.minus.bin.bed | awk '{print $2,$3,$4,$5,$1,$7}' OFS="\t" > temp.minus.bin2.bed
cat temp.plus.bin.bed temp.minus.bin2.bed | sort -k1,1 -k2,2n > $1.bin.bed
rm temp*
rm minus*