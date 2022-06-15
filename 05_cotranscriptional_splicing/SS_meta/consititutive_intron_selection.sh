#1. gtf to bed12
python ~/software/GFFtools-GX/gff_to_bed.py AtRTD2_19April2016.gtf > AtRTD2_gene.bed12 

#2. select exon from gtf file
awk '$3=="exon"{print $0}' AtRTD2_19April2016.gtf > exon.gtf
sort -k1,1 -k4,4n exon.gtf> exon.sort.gtf


./get_intron_from_BED12.sh AtRTD2_gene.bed12 | awk '{print $1,$2,$3,$4"_"$2"_"$3,1,$5}' > intron.bed
sort -k1,1 -k2,2n intron.bed | awk '!a[$1,$2,$3,$6]++' > intron.uniq.bed 
mergeBed -i intron.uniq.bed -s -c 4,5,6 -o first,sum,first > intron.merge.bed 
awk '$5==1{print $0}' intron.merge.bed > constutive.intron.bed
subtractBed -a constutive.intron.bed -b exon.bed -A -s > constitutive.intron.bed