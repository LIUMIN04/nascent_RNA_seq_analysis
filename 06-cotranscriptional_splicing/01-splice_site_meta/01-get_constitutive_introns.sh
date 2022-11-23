#exon bed
awk '$3=="exon"' atRTD3_TS_21Feb22_transfix.gtf > exon.gtf
cut -f 9 exon.gtf | cut -f 1-4 -d " " | sed -e 's/gene_id //g;s/"//g;s/ //g;s/transcript_id//g' | awk '{print substr($0,1,length($0)-1)}' | paste - exon.gtf | awk '{print $2,$5-1,$6,$1,1,$8}' OFS="\t" > exon.bed

#get constitutive intron
# get_intron_gtf_from_bed.pl can be downloaded from https://github.com/riverlee/IntronGTF/blob/master/get_intron_gtf_from_bed.pl
perl get_intron_gtf_from_bed.pl atRTD3_07082020.bed atRTD3_intron.gtf
cut -f 9 atRTD3_intron.gtf | cut -f 4 -d " " | sed -e 's/"//g'| cut -f 1,2 -d ";" | paste - atRTD3_intron.gtf | awk '{print $2,$5-1,$6,$1"_"$5"_"$6,1,$8}' OFS="\t" > intron.bed 
#remove duplicated intron
sort -k1,1 -k2,2n intron.bed | awk '!a[$1,$2,$3,$6]++' > intron.uniq.bed  
#remove wrong annotation
awk '$2<$3' intron.uniq.bed > intron.uniq2.bed 
#get introns nonoverlap with other introns
mergeBed -i intron.uniq2.bed -s -c 4,5,6 -o first,sum,first > intron.merge.bed
awk '$5==1{print $0}' intron.merge.bed > nonoverlap.intron.bed 
#remove introns overlapped with exons
subtractBed -a nonoverlap.intron.bed -b exon.bed -A -s > constitutive.intron.bed
