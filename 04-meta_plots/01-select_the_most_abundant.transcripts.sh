#select the most abundant transcript
salmon index -t atRTD3_29122021.fa -i atRTD3_salmon_index --type quasi -k 31
salmon quant -i ./atRTD3_salmon_index/ -p 16 -l ISR -1 total.clean.R1.fastq.gz -2 total.clean.R2.fastq.gz -o salmon_quant

cut -f 1,4 quant.sf | awk '$2>1' > total.TPM1.txt
cut -f 1 total.TPM1.txt | cut -f 1 -d "." | paste - total.TPM1.txt | sed '1d' | sort -k1,1 -k3,3nr  | awk '!a[$1]++' > Most.abundant.transcript.txt
cut -f 2 Most.abundant.transcript.txt  > Most.abundant.transcript.list
grep  -v "-" Most.abundant.transcript.list > Most.abundant.transcript.rm.fusion.txt

cut -f 4 atRTD3_07082020.bed | cut -f 2 -d ";" | paste - atRTD3_07082020.bed |sort -k1,1 > atRTD3.bed.sort &
join -1 1 -2 1 Most.abundant.transcript.rm.fusion.txt atRTD3.bed.sort | awk '{print $2,$3,$4,$1,$6,$7}' OFS="\t" | sort -k1,1 -k2,2n |  grep -v Chr[CM] > Most.abundant.transcript.rm.fusion.bed


# The up- and down-stream 1kb of TSS and PAS is divided into 10bp bin
#TSS
awk '{if($6=="+"){$7=$2-1000;$8=$2+1000;print$1,$7,$8,$4,$5,$6}else{$7=$3-1000;$8=$3+1000;print$1,$7,$8,$4,$5,$6}}' OFS="\t" Most.abundant.transcript.rm.fusion.bed > TSS1KB.bed
grep + TSS1KB.bed > TSS1KB.plus.bed
grep - TSS1KB.bed > TSS1KB.minus.bed
bedtools makewindows -b TSS1KB.plus.bed -n 200 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="+";print $0}' > TSS1KB.plus.bin.bed
bedtools makewindows -b TSS1KB.minus.bed -n 200 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="-";print $0}' > TSS1KB.minus.bin.bed
awk '{print $5}' TSS1KB.minus.bin.bed | tac > minus.tss1kb.order
paste minus.tss1kb.order TSS1KB.minus.bin.bed | awk '{print $2,$3,$4,$5,$1,$7}' OFS="\t" > TSS1KB.minus.bin2.bed
cat TSS1KB.plus.bin.bed TSS1KB.minus.bin2.bed | sort -k1,1 -k2,2n > TSS.200bin.bed


#PAS
awk '{if($6=="+"){$7=$3-1000;$8=$3+1000;print$1,$7,$8,$4,$5,$6}else{$7=$2-1000;$8=$2+1000;print$1,$7,$8,$4,$5,$6}}' OFS="\t" Most.abundant.transcript.rm.fusion.bed > PAS1KB.bed
grep + PAS1KB.bed > PAS1KB.plus.bed
grep - PAS1KB.bed > PAS1KB.minus.bed
bedtools makewindows -b PAS1KB.plus.bed -n 200 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="+";print $0}' > PAS1KB.plus.bin.bed
bedtools makewindows -b PAS1KB.minus.bed -n 200 -i srcwinnum | tr "_" "\t" | awk 'BEGIN{OFS="\t"}{$6="-";print $0}' > PAS1KB.minus.bin.bed
awk '{print $5}' PAS1KB.minus.bin.bed | tac > minus.tts1kb.order
paste minus.tts1kb.order PAS1KB.minus.bin.bed | awk '{print $2,$3,$4,$5,$1,$7}' OFS="\t" > PAS1KB.minus.bin2.bed
cat PAS1KB.plus.bin.bed PAS1KB.minus.bin2.bed | sort -k1,1 -k2,2n > PAS.200bin.bed

rm -f TSS1KB.bed PAS1KB.bed *plus* *minus*

#TSS.200bin.bed and PAS.200bin.bed are used to plot the meta-profile
