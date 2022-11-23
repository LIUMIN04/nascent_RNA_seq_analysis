#get sequencce information of 5'SS and 3'ss. all.merged.intron5.bed contains splice event detected by CB, Nuc and total.
awk '{if($6=="+"){print $1,$2-2,$2+2,$4,$5,$6}else{print $1,$3-2,$3+2,$4,$5,$6}}' OFS="\t" all.merged.intron5.bed > all.merged.intron5.bed.5SS.bed
awk '{if($6=="+"){print $1,$3-2,$3+2,$4,$5,$6}else{print $1,$2-2,$2+2,$4,$5,$6}}' OFS="\t" all.merged.intron5.bed > all.merged.intron5.bed.3SS.bed

bedtools getfasta -bed all.merged.intron5.bed.5SS.bed -fi /public/genome/arabidopsis/tair10/TAIR10_chr_all.fas -s -name -tab > all.merged.intron5.bed.5SS.bed.sequence
bedtools getfasta -bed all.merged.intron5.bed.3SS.bed -fi /public/genome/arabidopsis/tair10/TAIR10_chr_all.fas -s -name -tab > all.merged.intron5.bed.3SS.bed.sequence

paste all.merged.intron5.bed all.merged.intron5.bed.5SS.bed.sequence all.merged.intron5.bed.3SS.bed.sequence | cut -f 1,2,3,4,5,6,8,10 > all.merged.intron5.bed.5SS.3SS
rm -f all.merged.intron5.bed.3SS.bed all.merged.intron5.bed.3SS.bed.sequence all.merged.intron5.bed.5SS.bed all.merged.intron5.bed.5SS.bed.sequence

#self compare to get the overlapping information of detected introns
cp all.merged.intron5.bed.5SS.3SS  all.merged.intron5.bed.5SS.3SS.2
intersectBed -a all.merged.intron5.bed.5SS.3SS -b all.merged.intron5.bed.5SS.3SS.2 -s -wao > self.compare

#find intron pairs with the same 5'SS but different 3'SS, and the sequence in the RS site is "AGGT".
./anno.sh self.compare
cat self.compare.plus.anno self.compare.minus.anno | awk '$15=="A3SS_small" && $8=="AGGT"' > potential.RS.bed
cut -f 4,12 potential.RS.bed | awk '{print $1,$2,NR}' OFS="\t" > potential.RS.list 

#select the intron pairs as RS candidates if LSJ presented both in CB and total, and SSJ only presentes in total.
./RS_selection.sh

#retained candidates if the distance from 3'SS of short intron to the 3'SS of long intron > 20 nt. candidate.bed was produced from above step.
awk '($11-$10)-($3-$2) > 20' candidate.bed > candidate.filter.bed

#compared with annotated introns
cut -f 4 candidate.filter.bed | sort > SSJ.list
cut -f 12 candidate.filter.bed | sort > LSJ.list
comm -23 SSJ.list AtRTD.intron.list > SSJ.unannotated
comm -23 LSJ.list AtRTD.intron.list > LSJ.unannotated
