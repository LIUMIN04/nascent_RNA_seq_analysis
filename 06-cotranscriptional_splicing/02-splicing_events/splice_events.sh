#CB.intron.count.bed nuc.intron.count.bed total.intron.count.bed contain detected intron information by CB, NUC and total. 
#These files are obtained by extractJunctionFromBAM.sh 

#merge all detected introns, only introns detected at least 5 times were retained.
cat CB.intron.count.bed nuc.intron.count.bed total.intron.count.bed > all.merge.intron.bed
sort -k1,1 -k2,2n -k3,3n -k4,4 all.merge.intron.bed| groupBy -i - -g 1,2,3,4 -c 5 -o sum | awk '$5>5' > all.filter5.intron.bed
awk '{print $1,$2,$3,$1"_"$2"_"$3,1,$4,$5}' OFS="\t" all.filter5.intron.bed > all.filter5.intron.name.bed

#filtering artifact introns
cut -f 4 all.filter5.intron.name.bed | sort | uniq -c | awk '$1>1' > wrong.list
awk '{print $2}' wrong.list > wrong.list2
grep -f wrong.list2 all.filter5.intron.name.bed > wrong.list.intron.bed
sort -k4,4 -k7,7nr all.filter5.intron.name.bed | awk '!a[$4]++' > all.filter5.filter.intron.bed

#compaired with annotated introns in atRTD3 (intron.uniq2.bed), and get the unannotated introns. 
subtractBed -a all.filter5.filter.intron.bed -b intron.uniq2.bed -s | sort -k1,1 -k2,2n > unannotated.intron.bed


#CB splice events
cut -f 4 all.filter5.filter.intron.bed | sort > all.intron.list
awk '{print $1,$2,$3,$1"_"$2"_"$3,1,$4,$5}' OFS="\t" CB.intron.count.bed  > CB.intron.name.bed
cut -f 4 CB.intron.name.bed | sort > CB.intron.list
comm -12 all.intron.list CB.intron.list | sort | uniq > CB.final.intron.list

#CB unannotated splice events
cut -f 4 unannotated.intron.bed | sort > unannotated.intron.list
comm -12 CB.final.intron.list unannotated.intron.list | uniq > CB.unannotated.intron.list


#Nuc splice events
awk '{print $1,$2,$3,$1"_"$2"_"$3,1,$4,$5}' OFS="\t" nuc.intron.count.bed  > nuc.intron.name.bed
cut -f 4 nuc.intron.name.bed | sort > nuc.intron.list
comm -12 all.intron.list nuc.intron.list | sort | uniq > nuc.final.intron.list

#Nuc unannotated splice events
comm -12 nuc.final.intron.list unannotated.intron.list | uniq > nuc.unannotated.intron.list


#total splice events
awk '{print $1,$2,$3,$1"_"$2"_"$3,1,$4,$5}' OFS="\t" total.intron.count.bed  > total.intron.name.bed
cut -f 4 total.intron.name.bed | sort > total.intron.list
comm -12 all.intron.list total.intron.list | sort | uniq > total.final.intron.list

#total unannotated splice events
comm -12 total.final.intron.list unannotated.intron.list | uniq > total.unannotated.intron.list



##get sequence infromation of unannotated introns
awk '{if($6=="+"){print $1,$2-5,$2+5,$4,$5,$6}else{print $1,$3-5,$3+5,$4,$5,$6}}' OFS="\t" unannotated.intron.bed | bedtools getfasta -bed - -fi ~/PATH/TAIR10_chr_all.fas -s -name -tab > unannotated.5SS.10bp.bed.seq

awk '{if($6=="+"){print $1,$3-5,$3+5,$4,$5,$6}else{print $1,$2-5,$2+5,$4,$5,$6}}' OFS="\t" unannotated.intron.bed | bedtools getfasta -bed - -fi ~/PATH/TAIR10_chr_all.fas -s -name -tab > unannotated.3SS.10bp.bed.seq
 
 