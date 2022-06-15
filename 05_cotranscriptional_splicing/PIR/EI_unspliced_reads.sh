bedtools intersect -a constutive.5SS.4bp.bed -b $1 -wao -s > ${1/gff.bed/}5ss.intersect.txt
bedtools intersect -a constutive.3SS.4bp.bed -b $1 -wao -s > ${1/gff.bed/}3ss.intersect.txt
awk '$13>=3{print $0}' ${1/gff.bed/}5ss.intersect.txt | cut -f 4,10 | uniq > ${1/gff.bed/}5ss.reads.ID.txt
awk '$13>=3{print $0}' ${1/gff.bed/}3ss.intersect.txt | cut -f 4,10 | uniq > ${1/gff.bed/}3ss.reads.ID.txt
cat ${1/gff.bed/}5ss.reads.ID.txt ${1/gff.bed/}3ss.reads.ID.txt | sort | uniq |  groupBy -g 1 -c 1 -o count > ${1/gff.bed/}exon_intron.count.txt
