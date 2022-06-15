#merge splicing events of CB, Nuc and total，and filtering splicing events with intron > 10000 and count <5.
cat *count.bed | sort -k4,4 | groupBy -i - -g 1,2,3,4,6 -c 5 -o sum | awk '{print $1,$2,$3,$1"_"$2"_"$3,$6,$5}' OFS="\t" | sort -k4,4 -k5,5nr | awk '!a[$4]++' > all.merged.intron.bed 
awk '$5>=5 && $3-$2<10000' all.merged.intron.bed | sort -k1,1 -k2,2n > all.merged.intron5.bed

#get sequencce information of 5'SS and 3'ss
awk '{if($6=="+"){print $1,$2-2,$2+2,$4,$5,$6}else{print $1,$3-2,$3+2,$4,$5,$6}}' OFS="\t" all.merged.intron5.bed > all.merged.intron5.bed.5SS.bed
awk '{if($6=="+"){print $1,$3-2,$3+2,$4,$5,$6}else{print $1,$2-2,$2+2,$4,$5,$6}}' OFS="\t" all.merged.intron5.bed > all.merged.intron5.bed.3SS.bed

bedtools getfasta -bed all.merged.intron5.bed.5SS.bed -fi /public/genome/arabidopsis/tair10/TAIR10_chr_all.fas -s -name -tab > all.merged.intron5.bed.5SS.bed.sequence
bedtools getfasta -bed all.merged.intron5.bed.3SS.bed -fi /public/genome/arabidopsis/tair10/TAIR10_chr_all.fas -s -name -tab > all.merged.intron5.bed.3SS.bed.sequence

paste all.merged.intron5.bed all.merged.intron5.bed.5SS.bed.sequence all.merged.intron5.bed.3SS.bed.sequence | cut -f 1,2,3,4,5,6,8,10 > all.merged.intron5.bed.5SS.3SS
rm -f all.merged.intron5.bed.3SS.bed all.merged.intron5.bed.3SS.bed.sequence all.merged.intron5.bed.5SS.bed all.merged.intron5.bed.5SS.bed.sequence

#与已有的内含子关联（AtRTDv2）
intersectBed -a all.merged.intron5.bed.5SS.3SS -b ../annotation/AtRTDv2/intron.uniq.bed -s -wao > all.merged.intron5.bed.5SS.3SS.anno &

cut -f 4 all.merged.intron5.bed | sort > all.merged.intron5.bed.list &
awk '{print $1"_"$2"_"$3}' ../annotation/AtRTDv2/intron.uniq.bed | sort > AtRTD.intron.list
comm -23 all.merged.intron5.bed.list AtRTD.intron.list > new.splice.list  #注释中没有的intron
comm -12 all.merged.intron5.bed.list AtRTD.intron.list | wc -l   #与注释中相同的intron

clusterBed -i all.merged.intron5.bed -s > all.merged.intron5.cluster.bed &
groupBy -i all.merged.intron5.cluster.bed -g 7 -c 7 -o count | awk '$2==3{print $1}' >3cluster.txt
for i in `cat 3cluster.txt`;do awk '$7=='"$i"'' all.merged.intron5.cluster.bed >> all.merged.intron5.3cluster.bed ;done &

#不与注释重叠的
awk '$9=="."' all.merged.intron5.bed.5SS.3SS.anno > nooverlap_with_annoIntron
awk '$9!="."' all.merged.intron5.bed.5SS.3SS.anno > overlapWithannoIntron

cat all.merged.intron5.bed.5SS.3SS.anno.minus.anno all.merged.intron5.bed.5SS.3SS.anno.plus.anno | awk '$15=="A3SS_small" && $8=="AGGT"' > potential.RS.bed

cut -f 4,12 potential.RS.bed | awk '{print $1,$2,NR}' OFS="\t" > potential.RS.list &
./RS_selection
cut -f 4 candidate.bed | sort > 1.list
sort -k4,4 candidate.bed > candidate.bed.sort


cut -f 4 candidate.bed.sort | uniq -c | awk '$1>1' | awk '{print $2}'   > rm.list
grep -v -f rm.list candidate.bed.sort > candidate.bed.filter.sort


join -1 1 -2 4  araport11_AtRTD.intron.list.sort.nostrand candidate.bed.filter.sort | awk '{print $1}' > with.anno.list
grep -v -f with.anno.list candidate.bed.filter.sort > candidate.RS.53.BED