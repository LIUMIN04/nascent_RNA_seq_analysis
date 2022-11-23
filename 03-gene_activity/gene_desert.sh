awk '{$2=$2-3000;$3=$3+3000;print $0}' OFS="\t" atRTD3_07082020.bed | awk '{if($2<0){$2=0};print $0}' OFS="\t" | sort -k1,1 -k2,2n > atRTD3.extended3KB.bed
mergeBed -i atRTD3.extended5KB.bed > atRTD3.extended3KB.merge.bed
subtractBed -a tair10.genome.bed -b atRTD3.extended3KB.merge.bed > gene.desert.bed
awk '$3-$2>2000' gene.desert.bed > gene.desert.2kb.bed
bedtools makewindows -w 2000 -b gene.desert.2kb.bed  > gene.desert.2kb.bin.bed
