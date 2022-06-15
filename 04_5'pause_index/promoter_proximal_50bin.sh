grep + $1.bed > $1.plus.bed
grep - $1.bed > $1.minus.bed

bedtools makewindows -b $1.plus.bed -w 50 -s 5 -i srcwinnum | sort -k1,1 -k2,2n | tr "_" "\t" > $1.plus.shift5.50win.bed
bedtools makewindows -b $1.minus.bed -w 50 -s 5 -i srcwinnum | sort -k1,1 -k2,2n | tr "_" "\t" > $1.minus.shift5.50win.bed

awk 'BEGIN{OFS="\t"}{$6="+";print $0}' $1.plus.shift5.50win.bed > $1.plus.shift5.50win.strand.bed
awk 'BEGIN{OFS="\t"}{$6="-";print $0}' $1.minus.shift5.50win.bed > $1.minus.shift5.50win.strand.bed

cat $1.plus.shift5.50win.strand.bed $1.minus.shift5.50win.strand.bed | sort -k1,1 -k2,2n > $1.shift5.50win.strand.bed
