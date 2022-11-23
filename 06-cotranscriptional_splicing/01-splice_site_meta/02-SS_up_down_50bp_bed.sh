awk '{if($6=="+"){print $1,$2-50,$2+50,$4,$5,$6}else{$1,$3-50,$3+50,$4,$5,$6}}' OFS="\t" > EI100.bed
awk '{if($6=="+"){print $1,$3-50,$3+50,$4,$5,$6}else{$1,$2-50,$2+50,$4,$5,$6}}' OFS="\t" > IE100.bed

#up and down 50bp of 5'SS
awk '$6=="+"' OFS="\t" EI100.bed > temp.plus.bed
awk '$6=="-"' OFS="\t" EI100.bed > temp.minus.bed
bedtools makewindows -b temp.plus.bed -n 100-i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="+";print $0}' > temp.plus.bin.bed
bedtools makewindows -b temp.minus.bed -n 100 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="-";print $0}' > temp.minus.bin.bed
awk '{print $5}' temp.minus.bin.bed | tac > minus.order
paste minus.order temp.minus.bin.bed | awk '{print $2,$3,$4,$5,$1,$7}' OFS="\t" > temp.minus.bin2.bed
cat temp.plus.bin.bed temp.minus.bin2.bed | sort -k1,1 -k2,2n > EI100.bin.bed
rm temp*
rm minus*

#up and down 50bp of 3'SS
awk '$6=="+"' OFS="\t" IE100.bed > temp.plus.bed
awk '$6=="-"' OFS="\t" IE100.bed > temp.minus.bed
bedtools makewindows -b temp.plus.bed -n 100-i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="+";print $0}' > temp.plus.bin.bed
bedtools makewindows -b temp.minus.bed -n 100 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="-";print $0}' > temp.minus.bin.bed
awk '{print $5}' temp.minus.bin.bed | tac > minus.order
paste minus.order temp.minus.bin.bed | awk '{print $2,$3,$4,$5,$1,$7}' OFS="\t" > temp.minus.bin2.bed
cat temp.plus.bin.bed temp.minus.bin2.bed | sort -k1,1 -k2,2n > IE100.bin.bed
rm temp*
rm minus*

